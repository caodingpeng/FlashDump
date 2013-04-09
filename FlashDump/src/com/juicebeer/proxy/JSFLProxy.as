/**
 * Created with IntelliJ IDEA.
 * User: dingpengcao
 * Date: 4/8/13
 * Time: 12:32 PM
 * To change this template use File | Settings | File Templates.
 */
package com.juicebeer.proxy {
	import adobe.utils.MMExecute;
	import mx.utils.StringUtil;
	public class JSFLProxy {
		public static const JSFL_FILE:String="";
		
		public function JSFLProxy() {
			
		}
		public static function runJSFL(jsfl:String,funcName:String,... params:*):String
		{
			var result:String;
			try{
				var src:String=StringUtil.substitute("fl.runScript(fl.configURI{0},{1},{2});",jsfl,funcName,params.join(','));
				result = MMExecute(src);
			}catch(err:Error){
				trace(err.message);
			}
			
			return result;
		}
	}
}
