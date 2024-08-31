package;

#if LUA_ALLOWED
import lscript.LScript;
import llua.Lua;
import llua.LuaL;
import llua.State;
import llua.Convert;
#end

class FunkinLScript
{
    #if LUA_ALLOWED
    public var Ls:LScript = null;
    #end
    public var scriptName:String = '';
    public function new(script:String) {
		
		Ls = new LScript(script);
		try{
		    var resultStr:String = Lua.tostring(Ls.luaState, script)
    		if (Ls != null)
    		{
    		#if (windows || android)
    		openfl.Lib.application.window.alert(resultStr, 'Error on lua script!');
    		#else
    		FunkinLua.luaTrace('Error loading lua script: "$script"\n' + resultStr, true, false, flixel.util.FlxColor.RED);
    		#end
    		Ls = null;
    		return;
    		}
		}
		
		scriptName = script;
		Ls.parent = this;
		Ls.setVar("FlxG", flixel.FlxG);
		Ls.setVar("FlxSprite", flixel.FlxSprite);
		Ls.setVar("PlayState", PlayState);
		Ls.setVar("game", PlayState.instance);
		Ls.execute();
		Ls.callFunc("onCreate");
	}
	
	override public function update(elapsed:Float) {
		super.update(elapsed);
		Ls.callFunc("onUpdate", [elapsed]);
	}
}