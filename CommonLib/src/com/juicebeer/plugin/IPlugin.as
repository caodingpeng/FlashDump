/**
 * Created with IntelliJ IDEA.
 * User: cdingpeng
 * Date: 4/15/13
 * Time: 2:53 PM
 * To change this template use File | Settings | File Templates.
 */
package com.juicebeer.plugin {
    import flash.utils.Dictionary;

    public interface IPlugin {
        function get ID():String
        function get name():String;
        function get author():String;
        function get description():String;
        function get setting():Dictionary;
        function set setting(value:Dictionary):void;
    }
}
