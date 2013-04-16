/**
 * Created with IntelliJ IDEA.
 * User: cdingpeng
 * Date: 4/15/13
 * Time: 4:15 PM
 * To change this template use File | Settings | File Templates.
 */


/*
 * ================================================
 *  javascript import helper method
 * ================================================
 */
var jSFL_PATH = fl.configURI+"";


var included={};
function include(file)
{
    if(included[file])
    {
        return;
    }

    fl.runScript(jSFL_PATH+file+".jsfl");
    included[file]=true;
}

