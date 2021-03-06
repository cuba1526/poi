![Header](https://raw.githubusercontent.com/poooi/poi/master/assets/img/header.png)

[![Build Status](https://travis-ci.org/poooi/poi.svg?branch=master)](https://travis-ci.org/poooi/poi)
[![Backers on Open Collective](https://opencollective.com/poi/backers/badge.svg)](#backers) [![Sponsors on Open Collective](https://opencollective.com/poi/sponsors/badge.svg)](#sponsors) [![Build status](https://ci.appveyor.com/api/projects/status/apv2xngtej1m17he?svg=true)](https://ci.appveyor.com/project/KochiyaOcean/poi)
[![Dependencies](https://david-dm.org/poooi/poi.svg)](https://david-dm.org/poooi/poi)
[![DevDependencies](https://david-dm.org/poooi/poi/dev-status.svg)](https://david-dm.org/poooi/poi?type=dev)
[![license:mit](https://img.shields.io/badge/license-mit-blue.svg)](https://opensource.org/licenses/MIT)

Scalable KanColle browser and tool.

## Prebuilt Release Downloads

[GitHub release](https://github.com/poooi/poi/releases).

[cnpm (CN Mainland)](https://npm.taobao.org/mirrors/poi).

### UNOFFICIAL releases maintained by the community

[AUR (Arch Linux, maintained by @swordfeng)](https://aur.archlinux.org/packages/poi/).

Homebrew Cask (macOS, maintained by @darg20127).
```shell
brew update && brew cask install poi
```

## Features

+ Proxy
+ Cache
+ Analysis
+ Notification
+ Plugin Support

## Screenshots

![Preview 1](https://cloud.githubusercontent.com/assets/6753092/10863967/ebcc2b60-8018-11e5-9f74-9d0cf214fe49.png)

![Preview 2](https://cloud.githubusercontent.com/assets/6753092/10863968/ee4d8a96-8018-11e5-92ae-7f794864dca8.png)

[More screenshots are available here](https://github.com/poooi/poi/wiki/Screenshots)

## Run from dev version

First, get the __latest__ __x64__ version (__>= 7.6.x__) of [Node.js](https://nodejs.org) and [npm](https://npmjs.org) >= __5.0.x__.

``` shell
git clone https://github.com/poooi/poi && cd poi
npm install
npm run deploy
npm start
```

Tips:
- You do not have to run `npm install` and `npm run deploy` with every `git pull`, however they're recommended after a major version bump. In case of any dependency or `require` error, try re-running them.

- If you have installed packages with npm < 5.0, it is highly recommended to completely remove current `node_modules` folder and re-run `npm install`.

- If you have trouble downloading electron executables from github/amazonaws, [you may set ELECTRON_MIRROR environment variable](https://github.com/electron-userland/electron-download).

## Available Plugins
Many functionalities are provided as plugins, you may choose only what you want! [Here's a list of available plugins](https://github.com/poooi/poi/wiki/List-of-available-plugins).

## Contributing

Bug reports, suggestions, ideas, pull requests, and devs are always welcome :)

On plugin development, the [docs](https://github.com/poooi/poi/tree/master/docs) are available in Chinese and English.

Please feel free to contact us via:
- github issues
- [telegram group](https://telegram.me/joinchat/AoMUpkCr6B8uH7EUewq6eQ) for Chinese speaking user
- [telegram group](https://t.me/joinchat/ENYTxwoB7sKsPQmgKEFzJw) for world wide user (English / français / 日本語)
- QQ group
- weibo
- or anything else.


## Based on

+ [Electron](https://github.com/atom/electron)
+ [React](https://github.com/facebook/react)
+ [ReactBootstrap](https://github.com/react-bootstrap/react-bootstrap/)
+ [Redux](https://github.com/reactjs/redux)

## Contributors

This project exists thanks to all the people who contribute.
<a href="//github.com/poooi/poi/graphs/contributors"><img src="https://poooi.github.io/contributors/graph.svg" /></a>


## Backers

Thank you to all our backers! 🙏 [[Become a backer](https://opencollective.com/poi#backer)]

<a href="https://opencollective.com/poi#backers" target="_blank"><img src="https://opencollective.com/poi/backers.svg?width=890"></a>


## Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website. [[Become a sponsor](https://opencollective.com/poi#sponsor)]

<a href="https://opencollective.com/poi/sponsor/0/website" target="_blank"><img src="https://opencollective.com/poi/sponsor/0/avatar.svg"></a>
<a href="https://opencollective.com/poi/sponsor/1/website" target="_blank"><img src="https://opencollective.com/poi/sponsor/1/avatar.svg"></a>
<a href="https://opencollective.com/poi/sponsor/2/website" target="_blank"><img src="https://opencollective.com/poi/sponsor/2/avatar.svg"></a>
<a href="https://opencollective.com/poi/sponsor/3/website" target="_blank"><img src="https://opencollective.com/poi/sponsor/3/avatar.svg"></a>
<a href="https://opencollective.com/poi/sponsor/4/website" target="_blank"><img src="https://opencollective.com/poi/sponsor/4/avatar.svg"></a>
<a href="https://opencollective.com/poi/sponsor/5/website" target="_blank"><img src="https://opencollective.com/poi/sponsor/5/avatar.svg"></a>
<a href="https://opencollective.com/poi/sponsor/6/website" target="_blank"><img src="https://opencollective.com/poi/sponsor/6/avatar.svg"></a>
<a href="https://opencollective.com/poi/sponsor/7/website" target="_blank"><img src="https://opencollective.com/poi/sponsor/7/avatar.svg"></a>
<a href="https://opencollective.com/poi/sponsor/8/website" target="_blank"><img src="https://opencollective.com/poi/sponsor/8/avatar.svg"></a>
<a href="https://opencollective.com/poi/sponsor/9/website" target="_blank"><img src="https://opencollective.com/poi/sponsor/9/avatar.svg"></a>



## License
[The MIT License](https://github.com/poooi/poi/blob/master/LICENSE)