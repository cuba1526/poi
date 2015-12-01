path = require 'path-extra'
fs = require 'fs-extra'
remote = require 'remote'
dialog = remote.require 'dialog'
i18n = require 'i18n'
{__, __n} = i18n
{$, $$, _, React, ReactBootstrap, FontAwesome, ROOT} = window
{Grid, Col, Button, ButtonGroup, Input, Alert, OverlayTrigger, Tooltip} = ReactBootstrap
{config, toggleModal} = window
{APPDATA_PATH} = window
{showItemInFolder, openItem} = require 'shell'

Divider = require './divider'
NavigatorBar = require './navigator-bar'

language = navigator.language
if !(language in ['zh-CN', 'zh-TW', 'ja-JP', 'en-US'])
  switch language.substr(0,1).toLowerCase()
    when 'zh'
      language = 'zh-TW'
    when 'ja'
      language = 'ja-JP'
    else
      language = 'en-US'

PoiConfig = React.createClass
  getInitialState: ->
    language: config.get 'poi.language', language
    enableConfirmQuit: config.get 'poi.confirm.quit', false
    enableNotify: config.get 'poi.notify.enabled', true
    constructionNotify: config.get 'poi.notify.construction.enabled', 'true'
    expeditionNotify: config.get 'poi.notify.expedition.enabled', 'true'
    repairNotify: config.get 'poi.notify.repair.enabled', 'true'
    moraleNotify: config.get 'poi.notify.morale.enabled', 'true'
    othersNotify: config.get 'poi.notify.others.enabled', 'true'
    notifyVolume: config.get 'poi.notify.volume', 1.0
    mapStartCheckShip: config.get 'poi.mapstartcheck.ship', false
    freeShipSlot: config.get 'poi.mapstartcheck.freeShipSlot', 4
    mapStartCheckItem: config.get 'poi.mapstartcheck.item', true
    enableDMMcookie: config.get 'poi.enableDMMcookie', false
    disableHA: config.get 'poi.disableHA', false
    screenshotPath: config.get 'poi.screenshotPath', window.screenshotPath
    cachePath: config.get 'poi.cachePath', remote.getGlobal('DEFAULT_CACHE_PATH')
  handleSetConfirmQuit: ->
    enabled = @state.enableConfirmQuit
    config.set 'poi.confirm.quit', !enabled
    @setState
      enableConfirmQuit: !enabled
  handleDisableHA: ->
    enabled = @state.disableHA
    config.set 'poi.disableHA', !enabled
    @setState
      disableHA: !enabled
  handleSetDMMcookie: ->
    enabled = @state.enableDMMcookie
    config.set 'poi.enableDMMcookie', !enabled
    @setState
      enableDMMcookie: !enabled
  handleSetNotify: ->
    enabled = @state.enableNotify
    config.set 'poi.notify.enabled', !enabled
    @setState
      enableNotify: !enabled
  handleChangeNotifyVolume: (e) ->
    volume = @refs.notifyVolume.getValue()
    volume = parseFloat(volume)
    return if volume is NaN
    config.set('poi.notify.volume', volume)
    @setState
      notifyVolume: volume
  handleSetNotifyIndividual: (type) ->
    switch type
      when 'construction'
        enabled = @state.constructionNotify
        config.set "poi.notify.construction.enabled", !enabled
        @setState
          constructionNotify: !enabled
      when 'expedition'
        enabled = @state.expeditionNotify
        config.set "poi.notify.expedition.enabled", !enabled
        @setState
          expeditionNotify: !enabled
      when 'repair'
        enabled = @state.repairNotify
        config.set "poi.notify.repair.enabled", !enabled
        @setState
          repairNotify: !enabled
      when 'morale'
        enabled = @state.moraleNotify
        config.set "poi.notify.morale.enabled", !enabled
        @setState
          moraleNotify: !enabled
      when 'others'
        enabled = @state.othersNotify
        config.set "poi.notify.others.enabled", !enabled
        @setState
          othersNotify: !enabled
  handleSetMapStartCheckShip: ->
    enabled = @state.mapStartCheckShip
    config.set 'poi.mapstartcheck.ship', !enabled
    @setState
      mapStartCheckShip: !enabled
  handleSetMapStartCheckFreeShipSlot: (e) ->
    freeShipSlot = parseInt @refs.freeShipSlot.getValue()
    config.set 'poi.mapstartcheck.freeShipSlot', freeShipSlot
    @setState
      freeShipSlot: freeShipSlot
  handleSetMapStartCheckItem: ->
    enabled = @state.mapStartCheckItem
    config.set 'poi.mapstartcheck.item', !enabled
    @setState
      mapStartCheckItem: !enabled
  handleSetLanguage: (language) ->
    language = @refs.language.getValue()
    return if @state.language == language
    config.set 'poi.language', language
    i18n.setLocale language
    @setState {language}
  handleClearCookie: (e) ->
    remote.getCurrentWebContents().session.clearStorageData {storages: ['cookies']}, ->
      toggleModal __('Delete cookies'), __('Success!')
  handleClearCache: (e) ->
    remote.getCurrentWebContents().session.clearCache ->
      toggleModal __('Delete cache'), __('Success!')
  folderPickerOnDrop: (callback, e) ->
    e.preventDefault()
    droppedFiles = e.dataTransfer.files
    isDirectory = fs.statSync(droppedFiles[0].path).isDirectory()
    callback droppedFiles[0].path if isDirectory
  screenshotFolderPickerOnDrop: (e) ->
    @folderPickerOnDrop @setScreenshotPath, e
  screenshotFolderPickerOnClick: ->
    @synchronize =>
      fs.ensureDirSync @state.screenshotPath
      filenames = dialog.showOpenDialog
        title: __ 'Screenshot Folder'
        defaultPath: @state.screenshotPath
        properties: ['openDirectory', 'createDirectory']
      @setScreenshotPath filenames[0] if filenames isnt undefined
  cacheFolderPickerOnDrop: (e) ->
    @folderPickerOnDrop @setCachePath, e
  cacheFolderPickerOnClick: ->
    @synchronize =>
      fs.ensureDirSync @state.cachePath
      filenames = dialog.showOpenDialog
        title: __ 'Cache Folder'
        defaultPath: @state.cachePath
        properties: ['openDirectory', 'createDirectory']
      @setCachePath filenames[0] if filenames isnt undefined
  setScreenshotPath: (pathname) ->
    window.screenshotPath = pathname
    config.set 'poi.screenshotPath', pathname
    @setState
      screenshotPath: pathname
  setCachePath: (pathname) ->
    config.set 'poi.cachePath', pathname
    @setState
      cachePath: pathname
  onDrag: (e) ->
    e.preventDefault()
  synchronize: (callback) ->
    return if @lock
    @lock = true
    callback()
    @lock = false
  render: ->
    <form>
      <div className="form-group" id='navigator-bar'>
        <Divider text={__ 'Browser'} />
        <NavigatorBar />
        {
          if process.platform isnt 'darwin'
            <Grid>
              <Col xs={12}>
                <Input type="checkbox" label={__ 'Confirm before exit'} checked={@state.enableConfirmQuit} onChange={@handleSetConfirmQuit} />
              </Col>
            </Grid>
        }
      </div>
      <div className="form-group">
        <Divider text={__ 'Notification'} />
        <Grid>
          <div>
            <Col xs={6}>
              <Button bsStyle={if @state.enableNotify then 'success' else 'danger'} onClick={@handleSetNotify} style={width: '100%'}>
                {if @state.enableNotify then '√ ' else ''}{__ 'Enable notification'}
              </Button>
            </Col>
            <Col xs={6}>
              <OverlayTrigger placement='top' overlay={
                  <Tooltip id='poiconfig-volume'>{__ 'Volume'} <strong>{parseInt(@state.notifyVolume * 100)}%</strong></Tooltip>
                }>
                <Input type="range" ref="notifyVolume" onInput={@handleChangeNotifyVolume}
                  min={0.0} max={1.0} step={0.05} defaultValue={@state.notifyVolume} />
              </OverlayTrigger>
            </Col>
          </div>
          <div>
            <Col xs={12} style={marginTop: 10}>
              <ButtonGroup justified>
                <Button bsStyle={if @state.constructionNotify then 'success' else 'danger'}
                        onClick={@handleSetNotifyIndividual.bind this, 'construction'}
                        className='notif-button'>
                  {__ 'Construction'}
                </Button>
                <Button bsStyle={if @state.expeditionNotify then 'success' else 'danger'}
                        onClick={@handleSetNotifyIndividual.bind this, 'expedition'}
                        className='notif-button'>
                  {__ 'Expedition'}
                </Button>
                <Button bsStyle={if @state.repairNotify then 'success' else 'danger'}
                        onClick={@handleSetNotifyIndividual.bind this, 'repair'}
                        className='notif-button'>
                  {__ 'Docking'}
                </Button>
                <Button bsStyle={if @state.moraleNotify then 'success' else 'danger'}
                        onClick={@handleSetNotifyIndividual.bind this, 'morale'}
                        className='notif-button'>
                  {__ 'Morale'}
                </Button>
                <Button bsStyle={if @state.othersNotify then 'success' else 'danger'}
                        onClick={@handleSetNotifyIndividual.bind this, 'others'}
                        className='notif-button'>
                  {__ 'Others'}
                </Button>
              </ButtonGroup>
            </Col>
          </div>
        </Grid>
      </div>
      <div className="form-group" >
        <Divider text={__ 'Slot check'} />
        <div style={display: "flex", flexFlow: "row nowrap"}>
          <div style={flex: 2, margin: "0 15px"}>
            <Input type="checkbox" label={__ 'Ship slots'} checked={@state.mapStartCheckShip} onChange={@handleSetMapStartCheckShip} />
          </div>
          <div style={flex: 2, margin: "0 15px"}>
            <Input type="checkbox" label={__ 'Item slots'} checked={@state.mapStartCheckItem} onChange={@handleSetMapStartCheckItem} />
          </div>
        </div>
        <div style={flex: 2, margin: "0 15px"}>
          <Input type="number" label={__ 'Warn when the number of empty ship slots is less than'} ref="freeShipSlot" value={@state.freeShipSlot} onChange={@handleSetMapStartCheckFreeShipSlot} placeholder="船位警告触发数" />
        </div>
      </div>
      <div className="form-group">
        <Divider text={__ 'Cache and cookies'} />
        <Grid>
          <Col xs={6}>
            <Button bsStyle="danger" onClick={@handleClearCookie} style={width: '100%'}>
              {__ 'Delete cookies'}
            </Button>
          </Col>
          <Col xs={6}>
            <Button bsStyle="danger" onClick={@handleClearCache} style={width: '100%'}>
              {__ 'Delete cache'}
            </Button>
          </Col>
          <Col xs={12}>
            <Alert bsStyle='warning' style={marginTop: '10px'}>
              {__ 'If connection error occurs frequently, delete both of them.'}
            </Alert>
          </Col>
        </Grid>
      </div>
      <div className="form-group">
        <Divider text={__ 'Language'} />
        <Grid>
          <Col xs={6}>
            <Input type="select" ref="language" value={@state.language} onChange={@handleSetLanguage}>
              <option value="zh-CN">简体中文</option>
              <option value="zh-TW">正體中文</option>
              <option value="ja-JP">日本語</option>
              <option value="en-US">English</option>
            </Input>
          </Col>
        </Grid>
      </div>
      <div className="form-group">
        <Divider text={__ 'Screenshot Folder'} />
        <Grid>
          <Col xs={12}>
            <div className="folder-picker"
                 onClick={@screenshotFolderPickerOnClick}
                 onDrop={@screenshotFolderPickerOnDrop}
                 onDragEnter={@onDrag}
                 onDragOver={@onDrag}
                 onDragLeave={@onDrag}>
              {@state.screenshotPath}
            </div>
          </Col>
        </Grid>
      </div>
      <div className="form-group">
        <Divider text={__ 'Cache Folder'} />
        <Grid>
          <Col xs={12}>
            <div className="folder-picker"
                 onClick={@cacheFolderPickerOnClick}
                 onDrop={@cacheFolderPickerOnDrop}
                 onDragEnter={@onDrag}
                 onDragOver={@onDrag}
                 onDragLeave={@onDrag}>
              {@state.cachePath}
            </div>
          </Col>
        </Grid>
      </div>
      <div className="form-group">
        <Divider text={__ 'Advanced'} />
        <Grid>
          <Col xs={12}>
            <Input type="checkbox" label={__ 'Disable Hardware Acceleration'} checked={@state.disableHA} onChange={@handleDisableHA} />
          </Col>
          <Col xs={12}>
            <Input type="checkbox" label={__ 'Editing DMM Cookie\'s Region Flag'} checked={@state.enableDMMcookie} onChange={@handleSetDMMcookie} />
          </Col>
        </Grid>
      </div>
    </form>

module.exports = PoiConfig
