import { ViewModule, api } from './graphics/ViewModule.js'
import { EndScreenModule } from './endscreen-module/EndScreenModule.js'

export const modules = [
  ViewModule,
  EndScreenModule
]

export const playerColors = [
  '#ff1d5c', // radical red
  '#22a1e4', // curious blue
  '#ff8f16', // west side orange
  '#de6ddf', // lavender pink
  '#6ac371', // mantis green
  '#9975e2', // medium purple
  '#3ac5ca', // scooter blue
  '#ff0000' // solid red
]
export const gameName = 'Spring2021'

export const stepByStepAnimateSpeed = 3

export const options = [
  {
    title: 'DEBUG MODE',
    get: function () {
      return api.options.debugMode2
    },
    set: function (value) {
      api.options.debugMode2 = value
      api.setDebug()
    },
    values: {
      'ON': true,
      'OFF': false
    },
    default: false
  },{
    title: 'MESSAGES',
    get: function () {
      return api.options.messages
    },
    set: function (value) {
      api.options.messages = value
      api.setMessage()
    },
    values: {
      'NONE': 0,
      'ME': 1,
      'ALL': 2
    },
    default: 2
  },{
    title: 'SPECIAL FX',
    get: function () {
      return api.options.showSFX
    },
    set: function (value) {
      api.options.showSFX = value
    },
    values: {
      'ON': true,
      'OFF': false
    },
    default: true
  }
]
