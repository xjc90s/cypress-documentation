@App.module "TestsApp", (TestsApp, App, Backbone, Marionette, $, _) ->

  class Router extends App.Routers.Application
    module: TestsApp

    before: (params = {}) ->
      @checkNav(params)
      @updateAppEnv(params)

      App.vent.trigger "main:nav:choose", "Tests"

    checkNav: (params) ->
      ## quick hack to get rid of the left nav
      ## used for sauce labs automated tests
      if params.nav and params.nav is "false"
        App.config.trigger "remove:nav"

    updateAppEnv: (params) ->
      ## store whether this was existing
      existing = !!params.__env

      ## always set the __env on our params
      ## this allows the user to change the URL
      ## to switch our __env mode
      ## or if unchanged will just match our current environment
      params.__env ?= App.getCurrentEnvironment()

      ## always attempt to reset the env as well
      ## which will fire change events if necessary
      App.config.setEnv(params.__env)

      ## clear out the env from params
      ## if it didnt exist before so its not
      ## displayed in our URL
      delete params.__env if not existing

    actions:
      show: ->
        route: "tests/*id"

  router = new Router

  App.commands.setHandler "switch:to:manual:browser", (id, browser, version) ->
    obj = {id: id}

    ## if browser and version are set
    ## then extend the obj, else dont
    if browser and version
      _.extend obj,
        browser: browser
        version: version
        __env:   "host"

    router.to "show", obj
