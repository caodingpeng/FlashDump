/**
 * Created with IntelliJ IDEA.
 * User: cdingpeng
 * Date: 4/15/13
 * Time: 2:53 PM
 * To change this template use File | Settings | File Templates.
 */
package com.juicebeer {
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;

    import mx.events.ModuleEvent;

    import mx.modules.IModuleInfo;

    import mx.modules.ModuleManager;

    public class PluginManager extends EventDispatcher {
        private var _moduleLoaderCounter:int=0;

        protected var _plugins:Array;
        public function PluginManager() {
            _plugins=[];
        }

        private function initPlugins(pluginConfigs:Array):void
        {
            _moduleLoaderCounter=pluginConfigs.length;

            for each(var config:Dictionary in pluginConfigs)
            {
                var moduleInfo:IModuleInfo = ModuleManager.getModule(config.url);
                moduleInfo.addEventListener(ModuleEvent.READY, onModuleReady);
                moduleInfo.load();
            }
        }

        private function onModuleReady(event:ModuleEvent):void
        {
            //_plugins.push(event.module.factory.create());

            _moduleLoaderCounter--;

            if(_moduleLoaderCounter==0)
            {
                this.dispatchEvent(new Event(Event.COMPLETE));
            }
        }

    }
}
