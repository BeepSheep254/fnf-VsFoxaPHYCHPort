package flixel.system;

import flash.display.Graphics;
import flash.display.Sprite;
import flash.Lib;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flixel.FlxG;
import flixel.FlxState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class FlxSplash extends FlxState
{
	public static var nextState:Class<FlxState>;

	/**
	 * @since 4.8.0
	 */
	public static var muted:Bool = false;

	var _sprite:Sprite;
	var _gfx:Graphics;
	var _text:TextField;
    var _text2:TextField;

	var _times:Array<Float>;
	var _colors:Array<Int>;
	var _functions:Array<Void->Void>;
	var _curPart:Int = 0;
	var _cachedBgColor:FlxColor;
	var _cachedTimestep:Bool;
	var _cachedAutoPause:Bool;

    var _soundThing:FlxSound;

	override public function create():Void
	{
		_cachedBgColor = FlxG.cameras.bgColor;
		FlxG.cameras.bgColor = FlxColor.BLACK;

		// This is required for sound and animation to synch up properly
		_cachedTimestep = FlxG.fixedTimestep;
		FlxG.fixedTimestep = false;

		_cachedAutoPause = FlxG.autoPause;
		FlxG.autoPause = false;

		/*#if FLX_KEYBOARD
		FlxG.keys.enabled = false;
		#end*/

		_times = [0.041, 0.184, 0.334, 0.495, 0.636];
		_colors = [0x00b922, 0xffc132, 0xf5274e, 0x3641ff, 0x04cdfb];
		_functions = [drawGreen, drawYellow, drawRed, drawBlue, drawLightBlue];

		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		_sprite = new Sprite();
		FlxG.stage.addChild(_sprite);
		_gfx = _sprite.graphics;

		_text = new TextField();
		_text.selectable = false;
		_text.embedFonts = true;
		var dtf = new TextFormat(FlxAssets.FONT_DEFAULT, 16, 0xffffff);
		dtf.align = TextFormatAlign.CENTER;
		_text.defaultTextFormat = dtf;
		_text.text = "HaxeFlixel";

		FlxG.stage.addChild(_text);

        _text2 = new TextField();
		_text2.selectable = false;
		_text2.embedFonts = true;
        _text2.defaultTextFormat = dtf;
        _text2.text = "Made with";

        FlxG.stage.addChild(_text2);

        _text.visible = false;
        _text2.visible = false;

		onResize(stageWidth, stageHeight);

		#if FLX_SOUND_SYSTEM
		if (!muted)
		{
			_soundThing = FlxG.sound.load(FlxAssets.getSound("flixel/sounds/flixel"));
		}
		#end

        for (time in _times)
        {
            new FlxTimer().start(time, timerCallback);
        }

		lime.app.Application.current.window.focus();
	}

	override public function destroy():Void
	{
		_sprite = null;
		_gfx = null;
		_text = null;
		_times = null;
		_colors = null;
		_functions = null;
		super.destroy();
	}

    override public function update(elapsed:Float) {
        #if FLX_KEYBOARD
        if (FlxG.keys.justPressed.ENTER)
            onComplete(null);
        #end
    }

	override public function onResize(Width:Int, Height:Int):Void
	{
		super.onResize(Width, Height);

		_sprite.x = (Width / 2);
		_sprite.y = (Height / 2) - 20 * FlxG.game.scaleY;

		_text.width = Width / FlxG.game.scaleX;
		_text.x = 0;
		_text.y = _sprite.y + 80 * FlxG.game.scaleY;
        _text2.y = _sprite.y - 80 * FlxG.game.scaleY;
        _text2.width = Width / FlxG.game.scaleX;
        _text2.x = 0;

		_sprite.scaleX = _text.scaleX = FlxG.game.scaleX;
		_sprite.scaleY = _text.scaleY = FlxG.game.scaleY;
	}

	function timerCallback(Timer:FlxTimer):Void
	{
		_functions[_curPart]();
		_text.textColor = _colors[_curPart];
		_text.text = "HaxeFlixel";
		_curPart++;

		if (_curPart == 5)
		{
			// Make the logo a tad bit longer, so our users fully appreciate our hard work :D
			FlxTween.tween(_sprite, {alpha: 0}, 3, {ease: FlxEase.quadOut, onComplete: onComplete});
			FlxTween.tween(_text, {alpha: 0}, 3, {ease: FlxEase.quadOut});
            FlxTween.tween(_text2, {alpha: 0}, 3, {ease: FlxEase.quadOut});
		}
	}

	function drawGreen():Void
	{
        onStart();

		_gfx.beginFill(0x00b922);
		_gfx.moveTo(0, -37);
		_gfx.lineTo(1, -37);
		_gfx.lineTo(37, 0);
		_gfx.lineTo(37, 1);
		_gfx.lineTo(1, 37);
		_gfx.lineTo(0, 37);
		_gfx.lineTo(-37, 1);
		_gfx.lineTo(-37, 0);
		_gfx.lineTo(0, -37);
		_gfx.endFill();
	}

	function drawYellow():Void
	{
		_gfx.beginFill(0xffc132);
		_gfx.moveTo(-50, -50);
		_gfx.lineTo(-25, -50);
		_gfx.lineTo(0, -37);
		_gfx.lineTo(-37, 0);
		_gfx.lineTo(-50, -25);
		_gfx.lineTo(-50, -50);
		_gfx.endFill();
	}

	function drawRed():Void
	{
		_gfx.beginFill(0xf5274e);
		_gfx.moveTo(50, -50);
		_gfx.lineTo(25, -50);
		_gfx.lineTo(1, -37);
		_gfx.lineTo(37, 0);
		_gfx.lineTo(50, -25);
		_gfx.lineTo(50, -50);
		_gfx.endFill();
	}

	function drawBlue():Void
	{
		_gfx.beginFill(0x3641ff);
		_gfx.moveTo(-50, 50);
		_gfx.lineTo(-25, 50);
		_gfx.lineTo(0, 37);
		_gfx.lineTo(-37, 1);
		_gfx.lineTo(-50, 25);
		_gfx.lineTo(-50, 50);
		_gfx.endFill();
	}

	function drawLightBlue():Void
	{
		_gfx.beginFill(0x04cdfb);
		_gfx.moveTo(50, 50);
		_gfx.lineTo(25, 50);
		_gfx.lineTo(1, 37);
		_gfx.lineTo(37, 1);
		_gfx.lineTo(50, 25);
		_gfx.lineTo(50, 50);
		_gfx.endFill();
	}

    function onStart():Void
    {
        _soundThing.play();
        _text.visible = true;
        _text2.visible = true;
    }

	function onComplete(Tween:FlxTween):Void
	{
        _soundThing.stop();
		FlxG.cameras.bgColor = _cachedBgColor;
		FlxG.fixedTimestep = _cachedTimestep;
		FlxG.autoPause = _cachedAutoPause;
		#if FLX_KEYBOARD
		if (!FlxG.keys.enabled)
            FlxG.keys.enabled = true;
		#end
		FlxG.stage.removeChild(_sprite);
		FlxG.stage.removeChild(_text);
        FlxG.stage.removeChild(_text2);
		FlxG.switchState(Type.createInstance(nextState, []));
		FlxG.game._gameJustStarted = true;
	}
}