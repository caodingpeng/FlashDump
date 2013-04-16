/**
 * SWFConsole class
 * ==================================================
 * @author www.rohanlatimer.com.au
 * @version 07Aug09
 * ==================================================
 * creates a dev console for various dev needs.
 * 
 * 
 * COMMAND LIST
 * type these into the console including the preceding '!'
 * !resmon -int : shows the resource monitor. use '1' to enable, '0' to disable. eg. !resmon 1
 * 
 * CHANGING AN INSTANCE'S PROPERTY
 * simply type the instance name as you would in author time
 * eg. my_mc.visible = false
 * 
 * notes: 
 * - if you omit the equals and value, the property's current value will be displayed
 * - the property must be a public property.
 * - spaces are optional.
 * - do not put a semi-colon on the end!
 */

 
 
package rl.dev
{	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	
	public class SWFConsole extends Sprite
	{
		private static const VERSION:String = "1.1";
		private static const WELCOME_MESSAGE:String = "============================================================\nConsole \n============================================================"
		private static const HEADER_BG_COLOUR:int = 0x000000;
		private static const HEADER_BG_ALPHA:Number = 0;
		private static const HEADER_HEIGHT:int = 0;
		private static const SHADOW_COLOUR:int = 0x000000;
		private static const TEXT_COLOUR:int = 0xFFFFFF;
		private static const BACKGROUND_COLOUR:int = 0x000000;
		private static const BACKGROUND_ALPHA:Number = 0.7;
		private static const BACKGROUND_HEIGHT:int = 200;
		private static const SCROLLTRACK_COLOUR:int = 0x000000;
		private static const SCROLLTRACK_ALPHA:Number = 0.5;
		private static const SCROLLTRACK_WIDTH:int = 10;
		private static const SCROLLBUTTON_COLOUR:int = 0xFFFFFF;
		private static const SCROLLBUTTON_ALPHA:Number = 0.9;
		private static const SCROLLHANDLE_COLOUR:int = 0xFFFFFF;
		private static const SCROLLHANDLE_ALPHA:Number = 0.9;
		private static const SCROLLHANDLE_WIDTH:int = 10;
		private static const SCROLLHANDLE_HEIGHT:int = 60;
		private static const INPUTAREA_BG_COLOUR:int = 0x000000;
		private static const INPUTAREA_BG_ALPHA:Number = 0.7;
		private static const INPUTAREA_BG_HEIGHT:int = 30;
		private static const INPUT_BG_COLOUR:int = 0xFFFFFF;
		private static const INPUT_BG_ALPHA:Number = 0.2;
		private static const INPUT_BG_HEIGHT:int = 0;
		
		private static var _enabled:Boolean = false;
		private static var _traceEnabled:Boolean = false;
		
		// gui elements
		private static var _headerbg:Shape;
		private static var _headerText:TextField;
		private static var _headerTextShadow:TextField;
		private static var _headerTextFormat:TextFormat;
		private static var _headerTextShadowFormat:TextFormat;
		private static var _bg:Shape;
		private static var _text:TextField;
		private static var _textFormat:TextFormat;
		private static var _outputMask:Shape;
		private static var _scrollTrack:Shape;
		private static var _scrollButtonUpShape:Shape;
		private static var _scrollButtonDownShape:Shape;
		private static var _scrollButtonUp:Sprite;
		private static var _scrollButtonDown:Sprite;
		private static var _scrollHandle:Sprite;
		private static var _scrollHandleShape:Shape;
		private static var _inputAreaBg:Shape;
		private static var _inputBg:Shape;
		private static var _inputText:TextField;
		
		private static var _width:Number;
		private static var _height:Number;
		private static var _offset:Number;
		private static var _min:Number;
		private static var _max:Number;
		private static var _percent:Number;
		
		// misc
		private static var _lastcommands:Array;
		private static var _lastcommandsindex:Number;

		// utilities
		private static var _fps:Sprite;
		private static var _memUsage:Sprite;
		
		public static var _activated:Boolean = false;
		
		// fps vars
		private static const _FPS_REFRESH_RATE:uint = 1000;
		private static const _HISTORY_STATES:uint = 20;
		
		private static var _fpsValue:uint = 0;
		private static var _fpsTimer:Timer;
		private static var _frames:uint = 0;
		private static var _avg:Number = 0;
		private static var _history:Array;
		private static var _stageFrameRate:uint;
		private static var _fpsBg:Shape;
		private static var _txt_fps:TextField;
		private static var _txt_avgfps:TextField;
		
		// memusage vars
		private static const UPDATE_INTERVAL:int = 1000;
		
		private static var _txt_mem:TextField;
		private static var _timer:Timer;
		private static var _memBg:Shape;
		
		
		
		public function SWFConsole( width:Number, height:Number, traceEnabled:Boolean = false )
		{
			super();
			_width = width;
			_height = height;
			_traceEnabled = traceEnabled;
			
			if ( stage ) _init();
			else addEventListener( Event.ADDED_TO_STAGE, _init, false, 0, true );
		}
		
		
		
		private function _init( e:Event = null ):void
		{
			removeEventListener( Event.ADDED_TO_STAGE, _init );
			trace( "SWFConsole Initialised - ( ` ) to activate" );
			
			// create gui
			_createHeader();
			_createBackground();
			_createOutputArea();
			_createScrollBar();
			//_createInputArea();
			
			//x = -Math.ceil( ( stage.stageWidth - _stageWidth ) * 0.5 );
			//y = -Math.ceil( ( stage.stageHeight - _stageHeight ) * 0.5 );
			
			_activated = true;
			
			_lastcommands = new Array();
			_lastcommandsindex = 0;
			
			//output( WELCOME_MESSAGE );
			
			//stage.addEventListener( KeyboardEvent.KEY_UP, _keyListener, false, 0, true);
			stage.addEventListener( Event.RESIZE, _relocate, false, 0, true );
		}
		
		
		
		private function _createHeader():void
		{
			_headerbg = new Shape();
			_headerbg.graphics.beginFill( HEADER_BG_COLOUR, HEADER_BG_ALPHA );
			_headerbg.graphics.drawRoundRect(	0, 0, _width, HEADER_HEIGHT ,15,15 );
			_headerbg.graphics.endFill();
			_headerbg.cacheAsBitmap = true;
			addChild( _headerbg );
			
//			_headerTextShadowFormat = new TextFormat();
//			_headerTextShadowFormat.font = "_typewriter";
//			_headerTextShadowFormat.color = SHADOW_COLOUR;
//			_headerTextShadowFormat.italic = true;
//			
//			_headerTextShadow = new TextField();
//			_headerTextShadow.x = 12;
//			_headerTextShadow.y = 2;
//			_headerTextShadow.height = HEADER_HEIGHT;
//			_headerTextShadow.autoSize = TextFieldAutoSize.LEFT;
//			_headerTextShadow.multiline = false;
//			_headerTextShadow.defaultTextFormat = _headerTextShadowFormat;
//			_headerTextShadow.text = "Console";
			
			_headerTextFormat = new TextFormat();
			_headerTextFormat.font = "_typewriter";
			_headerTextFormat.color = TEXT_COLOUR;
			_headerTextFormat.bold;
			_headerTextFormat.italic = true;
			
			_headerText = new TextField();
			_headerText.x = 10;
			_headerText.height = HEADER_HEIGHT;
			_headerText.autoSize = TextFieldAutoSize.LEFT;
			_headerText.multiline = false;
			_headerText.defaultTextFormat = _headerTextFormat;
			_headerText.text = "Console";
			
			//addChild( _headerTextShadow );
			addChild( _headerText );
		}
		
		
		
		private function _createBackground():void
		{
			_bg = new Shape();
			_bg.graphics.beginFill( BACKGROUND_COLOUR, BACKGROUND_ALPHA );
			_bg.graphics.drawRoundRect(	0, 0, _width, _height ,15,15);
			_bg.graphics.endFill();
			_bg.cacheAsBitmap = true;

			addChild( _bg );
		}
		
		
		
		private function _createOutputArea():void
		{
			_text = new TextField();
			_text.width = _width-20;
			_text.x = 10;
			_text.y = HEADER_HEIGHT;
			_text.height = _height;
			_text.multiline = true;
			_text.wordWrap = true;
			_text.autoSize = TextFieldAutoSize.LEFT;
			
			_textFormat = new TextFormat();
			_textFormat.color = TEXT_COLOUR;
			_textFormat.font = "_typewriter";
			
			_text.defaultTextFormat = _textFormat;
			addChild( _text );
			
			_outputMask = new Shape();
			_outputMask.graphics.beginFill( 0xFF00FF );
			_outputMask.graphics.drawRect(	0, 0, _width, _height);
			_outputMask.graphics.endFill();
			_outputMask.x = 10;
			_outputMask.y = HEADER_HEIGHT;
			addChild( _outputMask );
			
			_text.mask = _outputMask;
		}
		
		
		
		private function _createScrollBar():void
		{
			_createScrollTrack();
			_createScrollButtons();
			_createScrollHandle();
			
			// hide scroll bar until needed
			_scrollTrack.visible = false;
			_scrollButtonUp.visible = false;
			_scrollButtonDown.visible = false;
			_scrollHandle.visible = false;
			
			_min = _scrollTrack.y;
			_max = _scrollTrack.y + _scrollTrack.height - _scrollHandle.height;
			
			_scrollHandle.buttonMode = true;
			_scrollHandle.addEventListener( MouseEvent.MOUSE_DOWN, _handleDown, false, 0, true );
			stage.addEventListener( MouseEvent.MOUSE_UP, _handleUp, false, 0, true );
			addEventListener( MouseEvent.MOUSE_WHEEL, _scrollWheel, false, 0, true );
		}
		
		
		
		private function _createScrollTrack():void
		{
			_scrollTrack = new Shape();
			_scrollTrack.graphics.beginFill( SCROLLTRACK_COLOUR, SCROLLTRACK_ALPHA );
			_scrollTrack.graphics.drawRect(	0, 0, SCROLLTRACK_WIDTH, _height - 60 );
			_scrollTrack.graphics.endFill();
			_scrollTrack.x = _width - 20;
			_scrollTrack.y = HEADER_HEIGHT + 30;
			_scrollTrack.cacheAsBitmap = true;
			addChild( _scrollTrack );
		}
		
		
		
		private function _createScrollButtons():void
		{
			_scrollButtonUpShape = new Shape();
			_scrollButtonDownShape = new Shape();
			_createScrollButtonShape( _scrollButtonUpShape );
			_createScrollButtonShape( _scrollButtonDownShape );
			
			_scrollButtonUp = new Sprite();
			_scrollButtonUp.addChild( _scrollButtonUpShape );
			_scrollButtonUp.x = _width - 20;
			_scrollButtonUp.y = 40;
			_scrollButtonUp.buttonMode = true;
			_scrollButtonUp.addEventListener( MouseEvent.MOUSE_DOWN, _scrollButtonUpDown, false, 0, true );
			addChild( _scrollButtonUp );
			
			_scrollButtonDown = new Sprite();
			_scrollButtonDown.addChild( _scrollButtonDownShape );
			_scrollButtonDown.scaleY = -1;
			_scrollButtonDown.x = _width - 20;
			_scrollButtonDown.y = _scrollTrack.y + _scrollTrack.height + 10;
			_scrollButtonDown.buttonMode = true;
			_scrollButtonDown.addEventListener( MouseEvent.MOUSE_DOWN, _scrollButtonDownDown, false, 0, true );
			addChild( _scrollButtonDown );
		}
		
		
		
		private function _createScrollButtonShape( container:Shape ):void
		{
			container.graphics.beginFill( SCROLLBUTTON_COLOUR, SCROLLBUTTON_ALPHA );
			container.graphics.moveTo( 0, 0 );
			container.graphics.lineTo( 5, -8 );
			container.graphics.lineTo( 10, 0 );
			container.graphics.lineTo( 0, 0 );
			container.graphics.endFill();
			container.cacheAsBitmap = true;
		}
		
		
		
		private function _scrollButtonUpDown( e:MouseEvent ):void
		{
			_percent -= 0.1;
			
			if ( _percent < 0 )
				_percent = 0;
				
			_text.y = _headerbg.height + ( ( -_percent * ( _text.height - _outputMask.height ) ) );
			_scrollHandle.y = _min + ( ( _max - _min ) * _percent );
		}
		
		
		
		private function _scrollButtonDownDown( e:MouseEvent ):void
		{
			_percent += 0.1;
			
			if ( _percent > 1.0 )
				_percent = 1.0;
				
			_text.y = _headerbg.height + ( ( -_percent * ( _text.height - _outputMask.height ) ) );
			_scrollHandle.y = _min + ( ( _max - _min ) * _percent );
		}
		
		
		
		private function _createScrollHandle():void
		{
			_scrollHandleShape = new Shape();
			_scrollHandleShape.graphics.beginFill( SCROLLHANDLE_COLOUR, SCROLLHANDLE_ALPHA );
			_scrollHandleShape.graphics.drawRect(	0, 0, SCROLLHANDLE_WIDTH, SCROLLHANDLE_HEIGHT );
			_scrollHandleShape.graphics.endFill();
			_scrollHandleShape.cacheAsBitmap = true;
			
			_scrollHandle = new Sprite();
			_scrollHandle.addChild( _scrollHandleShape );
			_scrollHandle.x = _scrollTrack.x - ( SCROLLHANDLE_WIDTH - SCROLLTRACK_WIDTH );
			_scrollHandle.y = _scrollTrack.y;
			addChild( _scrollHandle );
		}
		
		
		
		private function _handleDown( e:MouseEvent ):void
		{
			stage.addEventListener( MouseEvent.MOUSE_MOVE, _handleMove, false, 0, true );
			_offset = mouseY - _scrollHandle.y;
		}
		
		
		
		private function _handleUp( e:MouseEvent ):void
		{
			stage.removeEventListener( MouseEvent.MOUSE_MOVE, _handleMove );
		}
		
		
		
		private function _scrollWheel( e:MouseEvent ):void
		{
			if ( _scrollButtonDown.visible )
			{
				if ( e.delta > 0 )
				{
					_percent -= 0.1;
					
					if ( _percent < 0 )
						_percent = 0;
				}
				else if ( e.delta < 0 )
				{
					_percent += 0.1;
					
					if ( _percent > 1 )
						_percent = 1;
				}
				
				_text.y = _headerbg.height + ( ( -_percent * ( _text.height - _outputMask.height ) ) );
				_scrollHandle.y = _min + ( ( _max - _min ) * _percent );
			}
		}
		
		
		
		private function _handleMove( e:MouseEvent ):void
		{
			_scrollHandle.y = mouseY - _offset;
			if ( _scrollHandle.y <= _min )
				_scrollHandle.y = _min;
				
			if ( _scrollHandle.y >= _max )
				_scrollHandle.y = _max;
				
			_percent = ( _scrollHandle.y - _min ) / ( _max - _min );
			if ( _text.height > _outputMask.height )
				_text.y = _headerbg.height + ( ( -_percent * ( _text.height - _outputMask.height ) ) );
				
			e.updateAfterEvent();
		}
		
		
		
		private function _createInputArea():void
		{
			_inputAreaBg = new Shape();
			_inputAreaBg.graphics.beginFill( INPUTAREA_BG_COLOUR, INPUTAREA_BG_ALPHA );
			_inputAreaBg.graphics.drawRect(	0, 0, stage.stageWidth, INPUTAREA_BG_HEIGHT );
			_inputAreaBg.graphics.endFill();
			_inputAreaBg.y = HEADER_HEIGHT + BACKGROUND_HEIGHT;
			addChild( _inputAreaBg );
			
			_inputBg = new Shape();
			_inputBg.graphics.beginFill( INPUT_BG_COLOUR, INPUT_BG_ALPHA );
			_inputBg.graphics.drawRect(	0, 0, stage.stageWidth - 50, INPUT_BG_HEIGHT );
			_inputBg.graphics.endFill();
			_inputBg.x = 10;
			_inputBg.y = _inputAreaBg.y + 5;
			addChild( _inputBg );
			
			_inputText = new TextField();
			_inputText.width = stage.stageWidth - 50;
			_inputText.x = 10;
			_inputText.y = _inputAreaBg.y + 5;
			_inputText.height = INPUT_BG_HEIGHT;
			_inputText.multiline = false;
			_inputText.type = TextFieldType.INPUT;
			_inputText.restrict = "^`";
			
			_inputText.defaultTextFormat = _textFormat;
			addChild( _inputText );
		}
		
		
		
		private function _keyListener( e:KeyboardEvent ):void
		{
			if ( _activated ) 
			{
				switch ( e.keyCode )
				{
					case 192 : // tilda ( ~ )
						if ( _enabled )
							hide();
						else
						{
							_inputText.text = "";
							show();
							stage.focus = _inputText;
						}
						_enabled = !_enabled;
						break;
						
					case 13 : // Enter 
						_processCommand( _inputText.text );
						_inputText.text = "";
						break;
						
					case 38 : // Up Arrow
						if ( _lastcommands.length > 0 )
						{
							_inputText.text = _lastcommands[ _lastcommandsindex ];
							_inputText.setSelection( _inputText.length, _inputText.length );
							_lastcommandsindex--;
							if ( _lastcommandsindex < 0 )
								_lastcommandsindex = 0;
						}
						break;
				}
			}
		}
		
		
		
		/**
		 * processCommand is the guts of commands in SWFConsole.
		 * @param	command
		 */
		private function _processCommand( command:String ):void
		{
			// output command to console
			output( "> " + command );
			
			// add command to history array
			_lastcommands.push( command );
			_lastcommandsindex = _lastcommands.length - 1;
			
			// first remove all whitespace
			command = _removeWhitespace( command );
			
			//EMPTY
			if ( command == "" )
				return;
			
			// if the command starts with an ! then run a command
			if ( command.charAt( 0 ) == "!" )
				_runCommand( command );
			// if the command contains a bracket '(' then process a function
			else if ( _findChar( command, "(" ) )
				_runFunc( command );
			// otherwise run the property change
			else
				_runProperty( command );
		}
		
		
		
		/**
		 * Runs console commands
		 * @param	command - the command to run
		 */
		private function _runCommand( command:String ):void
		{
			if ( command.substr( 0, 7 ).toLowerCase() == "!resmon" )
			{
				if ( command.charAt( 7 ) == "0" )
				{
					if ( _fps != null )
						_fps.visible = false;
						
					if ( _memUsage != null )
						_memUsage.visible = false;
						
					output( "*** RESOURCE MONITOR DISABLED ***" );
				}
				else
				{
					if ( _fps == null )
						_initFPS();
					else
						_fps.visible = true;
						
					if ( _memUsage == null )
						_initMemUsage();
					else
						_memUsage.visible = true;
						
					output( "*** RESOURCE MONITOR ENABLED ***" );
				}
				
				return;
			}
			
			output( "Invalid command");
		}
		
		
		
		private function _runFunc( command:String ):void
		{
			var instanceSplit:Array;
			var functionSplit:Array;
			var parametersSplit:Array;
			var instance:Object;
			
			// if '.' is found, then modifying an instance, else stage
			if ( _findChar( command, "." ) ) 
			{
				instanceSplit = command.split( "." );
				instance = _recurseChildren( stage, instanceSplit[0] );
				functionSplit = instanceSplit[1].split( "(" );
				parametersSplit = functionSplit[1].split( ")" );
				
				// if instance is found
				if ( instance )
				{
					// if property is found
					if ( instance.hasOwnProperty( functionSplit[0] ) )
					{
						// run func
						try
						{
							// if no parameters
							if ( parametersSplit[0] == "" )
								output( instance[ functionSplit[0] ]() );
							else
							{
								// remove quotes if a string
								if ( _findChar( parametersSplit[0], "\"" ) )
									parametersSplit[0] = _removeChar( parametersSplit[0], "\"" );
								output( instance[ functionSplit[0] ]( parametersSplit[0] ) );
							}
						}
						catch ( e:Error )
						{
							output( e.toString() );
						}
					}
					else
					{
						output( "Function " + functionSplit[0] + " not found on " + instanceSplit[0] );
					}
				}
				else
				{
					output( "Instance not found" );
				}
			}
			else
			{
				functionSplit = command.split( "(" );
				parametersSplit = functionSplit[1].split( ")" );
				
				// if property is found
				if ( stage.hasOwnProperty( functionSplit[0] ) )
				{
					// run func
					try
					{
						// if no parameters
						if ( parametersSplit[0] == "" )
							output( stage[ functionSplit[0] ]() );
						else
						{
							// remove quotes if a string
							if ( _findChar( parametersSplit[0], "\"" ) )
								parametersSplit[0] = _removeChar( parametersSplit[0], "\"" );
							output( stage[ functionSplit[0] ]( parametersSplit[0] ) );
						}
					}
					catch ( e:Error )
					{
						output( e.toString() );
					}
				}
				else
				{
					output( "Function " + functionSplit[0] + " not found on " + instanceSplit[0] );
				}
			}
		}
		
		
		
		/**
		 * outputs or changes a display object's property
		 * @param	command - the command to run
		 */
		private function _runProperty( command:String ):void
		{
			var instanceSplit:Array;
			var propertySplit:Array;
			var instance:Object;
			
			// first, determine if an equals is present or not
			if ( _findChar( command, "=" ) )
			{
				propertySplit = command.split( "=" );
				
				// if '.' is found, then modifying an instance, else stage
				if ( _findChar( propertySplit[0], "." ) ) 
				{
					instanceSplit = propertySplit[0].split( "." );
					instance = _recurseChildren( stage, instanceSplit[0] );
					
					// if instance is found
					if ( instance )
					{
						// if property is found
						if ( instance.hasOwnProperty( instanceSplit[1] ) )
						{
							if ( propertySplit[1] == "false" )
								propertySplit[1] = false;
							instance[ instanceSplit[1] ] = propertySplit[1];
						}
						else
						{
							output( "Property " + instanceSplit[1] + " not found on " + instanceSplit[0] );
						}
					}
					else
					{
						output( "Instance not found" );
					}
				}
				else
				{
					// if property exists
					if ( stage.hasOwnProperty( propertySplit[0] ) )
					{
						if ( propertySplit[1] == "false" )
							propertySplit[1] = false;
						try
						{
							stage[ propertySplit[0] ] = propertySplit[1];
						}
						catch ( e:Error )
						{
							output( "*** ERROR: this property of stage cannot be set ***" );
						}
					}
					else
						output( "Property " + propertySplit[0] + " not found on stage" );
				}
			}
			// no equals found so display value
			else
			{
				// if a dot is present, search for instance, otherwise use stage
				if ( _findChar( command, "." ) ) 
				{
					instanceSplit = command.split( "." );
					instance = _recurseChildren( stage, instanceSplit[0] );
					
					// if instance is found
					if ( instance )
					{
						// if property is found
						if ( instance.hasOwnProperty( instanceSplit[1] ) )
						{
							output( instance.name + "." + instanceSplit[1] + " = " + instance[ instanceSplit[1] ] );
						}
						else
						{
							output( "Property " + instanceSplit[1] + " not found on " + instanceSplit[0] );
						}
					}
					else
					{
						output( "Instance not found" );
					}
				}
				else
				{
					// if property exists
					if ( stage.hasOwnProperty( command ) )
						output( "stage." + command + " = " + stage[ command ] );
					else
						output( "Property " + command + " not found on stage" );
				}
			}
		}
		
		
		
		/**
		 * Loops through a string and searches for the character supplied
		 * @param	command
		 * @return
		 */
		private function _findChar( command:String, char:String ):Boolean
		{			
			for ( var i:uint = 0; i < command.length; i++ )
				if ( command.charAt( i ) == char )
					return true;
					
			return false;
		}
		
		
		
		/**
		 * Removes any spaces from a string
		 * @param	str
		 * @return
		 */
		private function _removeWhitespace( str:String ):String
		{
			var tempStr:String = "";
			
			for ( var i:uint = 0; i < str.length; i++ )
			{
				if ( str.charAt(i) != " " )
					tempStr += str.charAt(i);
			}
			return tempStr;
		}
		
		
		
		/**
		 * Removes the specified character from a string
		 * @param	str
		 * @param	char
		 * @return
		 */
		private function _removeChar( str:String, char:String ):String
		{
			var tempStr:String = "";
			
			for ( var i:uint = 0; i < str.length; i++ )
			{
				if ( str.charAt(i) != char )
					tempStr += str.charAt(i);
			}
			return tempStr;
		}
		
		
		
		private function _relocate ( e:Event ):void
		{
			_headerbg.width = stage.stageWidth;
			_bg.width = stage.stageWidth;
			_text.width = stage.stageWidth - 50;
			_outputMask.width = stage.stageWidth - 50;
//			_inputText.width = stage.stageWidth - 50;
//			_inputAreaBg.width = stage.stageWidth;
//			_inputBg.width = stage.stageWidth - 50;
			_scrollTrack.x = Math.ceil( stage.stageWidth - 30 );
			_scrollButtonUp.x = Math.ceil( stage.stageWidth - 30 );
			_scrollButtonDown.x = Math.ceil( stage.stageWidth - 30 );
			_scrollHandle.x = Math.ceil( stage.stageWidth - 30 );
			
			//x = Math.ceil( ( -( stage.stageWidth - _stageWidth ) * 0.5 ) );
			//y = Math.ceil( ( -( stage.stageHeight - _stageHeight ) * 0.5 ) );
			
			if ( _fps )
			{
				//_fps.x = Math.ceil( ( -( stage.stageWidth - _stageWidth ) * 0.5 ) + ( stage.stageWidth - _fps.width ) );
				//_fps.y = Math.ceil( ( -( stage.stageHeight - _stageHeight ) * 0.5 ) + ( stage.stageHeight - _fps.height ) );
			}
			
			if ( _memUsage )
			{
				//_memUsage.x = Math.ceil( ( -( stage.stageWidth - _stageWidth ) * 0.5 ) + ( stage.stageWidth - _memUsage.width ) );
				//_memUsage.y = Math.ceil( ( -( stage.stageHeight - _stageHeight ) * 0.5 ) + ( stage.stageHeight - _memUsage.height ) - 32 );
			}
		}
		
		private function _recurseChildren( dispObj:Object, child:String ):Object
		{
			var target:Object;
			
			if ( dispObj.hasOwnProperty( "numChildren" ) == false || dispObj.numChildren == null || dispObj.numChildren == 0 )
				return target;
			
			for ( var i:uint = 0; i < dispObj.numChildren; i++ )
			{
				if ( dispObj.getChildAt(i).name == child )
				{
					return dispObj.getChildAt(i);
				}
				else
				{
					if( target == null )
						target = _recurseChildren( dispObj.getChildAt(i) as Object, child );
				}
			}
			
			return target;
		}
		
		
		
		/**
		 * FPS init
		 */
		private function _initFPS():void
		{
			_fps = new Sprite();
			stage.addChild( _fps );
			
			_stageFrameRate = stage.frameRate;
			_history = new Array();
			
			_txt_fps = new TextField();
			_txt_fps.width = 100;
			_txt_fps.height = 16;
      _txt_fps.border = false;
			_txt_fps.selectable = false;
			
			_txt_avgfps = new TextField();
			_txt_avgfps.width = 100;
			_txt_avgfps.height = 16;
      _txt_avgfps.border = false;
			_txt_avgfps.selectable = false;
			
      var format:TextFormat = new TextFormat();
			format.font = "Verdana";
			format.color = 0xffcc00;
			format.size = 10;
			
			_txt_fps.defaultTextFormat = format;
			_txt_avgfps.defaultTextFormat = format;
			
			_txt_fps.text = "FPS: " + _stageFrameRate;
			_txt_avgfps.text = "AVG: " + _stageFrameRate;
			
			_txt_fps.x = _txt_fps.width - _txt_avgfps.width;
			_txt_avgfps.x = 0;
			_txt_avgfps.y = _txt_fps.height;
			
			_fps.addChild( _txt_fps );
			_fps.addChild( _txt_avgfps );
			
			_fpsBg = new Shape();
			_fpsBg.graphics.beginFill( 0x000000, 0.7 );
			_fpsBg.graphics.drawRect( 0, 0, _fps.width, _fps.height );
			_fpsBg.graphics.endFill();
			_fps.addChildAt( _fpsBg, 0 );
			
			//_fps.x = Math.ceil( ( -( stage.stageWidth - _stageWidth ) * 0.5 ) + ( stage.stageWidth - _fps.width ) );
			//_fps.y = Math.ceil( ( -( stage.stageHeight - _stageHeight ) * 0.5 ) + ( stage.stageHeight - _fps.height ) );
			
			_fpsTimer = new Timer( _FPS_REFRESH_RATE );
			_fpsTimer.addEventListener( TimerEvent.TIMER, _calculateFPS, false, 0, true );
			_fpsTimer.start();
			
			addEventListener( Event.ENTER_FRAME, _updateFrames, false, 0, true );
		}
		
		
		
		private function _calculateFPS( e:TimerEvent ):void
		{
			_fpsValue = ( _frames > _stageFrameRate ) ? _stageFrameRate : _frames;
			_txt_fps.text = "FPS: " + String( _fpsValue );
			_frames = 0;
			
			_history.unshift( _fpsValue );
			if ( _history.length > _HISTORY_STATES )
				_history.pop();
			
			_avg = 0;
			
			for( var i:uint = 0; i < _history.length; i++ )
			{
				_avg += _history[i];
			}
			_txt_avgfps.text = "AVG: " + String( Math.round( _avg / ( _history.length ) ) );
		}
		
		
		
		private function _updateFrames( e:Event ):void
		{
			_frames++;
		}
		
		
		
		/**
		 * MemUsage Init
		 */
		private function _initMemUsage():void
		{
			_memUsage = new Sprite();
			stage.addChild( _memUsage );
			
			_txt_mem = new TextField();
			_txt_mem.width = 100;
			_txt_mem.height = 16;
      _txt_mem.border = false;
			_txt_mem.selectable = false;

      var format:TextFormat = new TextFormat();
			format.font = "Verdana";
			format.color = 0x66ff66;
			format.size = 10;

      _txt_mem.defaultTextFormat = format;
			_txt_mem.text = "MEM: 0 MB";
			
			_memUsage.addChild( _txt_mem );
			
			_memBg = new Shape();
			_memBg.graphics.beginFill( 0x000000, 0.7 );
			_memBg.graphics.drawRect( 0, 0, _memUsage.width, _memUsage.height );
			_memBg.graphics.endFill();
			_memUsage.addChildAt( _memBg, 0 );
			
			//_memUsage.x = Math.ceil( ( -( stage.stageWidth - _stageWidth ) * 0.5 ) + ( stage.stageWidth - _memUsage.width ) );
			//_memUsage.y = Math.ceil( ( -( stage.stageHeight - _stageHeight ) * 0.5 ) + ( stage.stageHeight - _memUsage.height ) - 32 );
			
			_timer = new Timer( UPDATE_INTERVAL );
			_timer.addEventListener( TimerEvent.TIMER, displayUsage, false, 0, true );
			_timer.start();
		}
		
		
		
		private function displayUsage( e:TimerEvent ):void
		{
			_txt_mem.text = "MEM: " + String( Number( System.totalMemory / 1024 / 1024 ).toFixed( 2 ) + "MB" );
		}
		
		
		
		// PUBLIC FUNCTIONS
		/**
		 * add swfconsole to the stage
		 * @param	o
		 */
		public static function init( o:Object, traceEnabled:Boolean = false ):void
		{
			o.stage.addChild( new SWFConsole( o.stage.width, o.stage.height, traceEnabled ) );	
		}
		
		 
		public static function clear( ):void
		{
			_text.htmlText="";
			
			_scrollTrack.visible = false;
			_scrollButtonUp.visible = false;
			_scrollButtonDown.visible = false;
			_scrollHandle.visible = false;
		}
		/**
		 * ouput whatever you need to SWFConsole
		 * @param	o
		 */
		public static function output( o:String ):void
		{
			if ( _activated ) 
			{
				_text.htmlText+=( String( o ) + "\n" );
				if ( _text.height > _outputMask.height )
				{
					_text.y = _headerbg.height -( _text.height - _outputMask.height );
					_scrollHandle.y = _max;
					_percent = 1.0;
					
					// if scrollbar not enabled
					if ( !_scrollButtonDown.visible )
					{
						_scrollTrack.visible = true;
						_scrollButtonUp.visible = true;
						_scrollButtonDown.visible = true;
						_scrollHandle.visible = true;
					}
				}
			}
			
			if ( _traceEnabled )
			{
				trace( String( o ) );
			}			
		}
		
		
		
		public function hide():void
		{
			alpha = 0;
			visible = false;
		}
		
		
		
		public function show():void
		{
			alpha = 1;
			visible = true;
			stage.focus = _inputText;
		}
	}
}