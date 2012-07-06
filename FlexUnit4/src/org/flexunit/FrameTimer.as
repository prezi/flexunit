package org.flexunit {

	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.display.Shape;
	import flash.utils.getTimer;

	public class FrameTimer extends EventDispatcher
	{
		private var frameDelay:int;
		private var msDelay:Number;

		private var _shape:Shape;

		private var _running:Boolean = false;
		private var frameCount:int = 0;
		private var timeStarted:int = 0;

		public function FrameTimer(delay:Number, waitForThirtyFps:Boolean = true)
		{
			_shape = new Shape();
			msDelay = delay;

			if (waitForThirtyFps)
			{
				frameDelay = Math.ceil(delay / 30.);
			}
			else
			{
				frameDelay = 0;
			}

			trace("FrameTimer: created");
		}

		public function start():void
		{
			timeStarted = getTimer();
			frameCount = 0;
			
			trace("FrameTimer: start");

			if (!_running)
			{
				_shape.addEventListener(Event.ENTER_FRAME, handleEnterFrame);
				_running = true;
			}
		}

		public function stop():void
		{
			if (!_running)
			{
				return;
			}

			trace("FrameTimer: stop (elapsed: " + (getTimer() - timeStarted) + ")");

			_running = false;
			_shape.removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
		}

		public function get running():Boolean
		{
			return _running;
		}

		private function handleEnterFrame(e:Event):void
		{
			if (!_running)
			{
				_shape.removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
				return;
			}

			var timeElapsed:int = getTimer() - timeStarted;
			frameCount += 1;

			trace("FrameTimer: frame " + frameCount + ", elapsed: " + timeElapsed + ", delay: " + msDelay);

			if (frameCount >= frameDelay && timeElapsed >= msDelay)
			{
				trace("FrameTimer: complete (elapsed: " + timeElapsed + ")");
				dispatchEvent(new TimerEvent(TimerEvent.TIMER_COMPLETE));
			}
		}
	}
}