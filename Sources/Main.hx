package;

import kha.Window;
import kha.Display;
import kha.Assets;
import kha.Color;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;

class Main {
	static var wWidth:Int;
	static var wHeight:Int;

	static var rectWidth:Float;
	static var rectHeight:Float;
	static var x:Float;
	static var y:Float;
	static var speed:Float;

	static var updateInterval:Float;
	static var lastTime:Float;
	static var updateCount:Int;

	static function update(): Void {
		final now = Scheduler.time();
		final delta = now - lastTime;
		lastTime = now;

		//Pick one, makes no difference for the bug.

		x += speed * updateInterval;
		//x += speed * delta;

		//==========================================

		if (x > wWidth) {
			x = 0;
		}
		
		updateCount++;
		trace("[Update Count: " + updateCount + "] [Time Delta: " + delta + "]");
	}

	static function render(frames: Array<Framebuffer>): Void {
		final fb = frames[0];
		final g2 = fb.g2;

		//Just show we're still rendering properly
		final color = Math.abs(Math.sin(Scheduler.realTime() * 2));

		g2.begin();
		g2.color = Color.fromFloats(1, color, 0);
		g2.fillRect(x, y, rectWidth, rectHeight);
		g2.end();
	}

	public static function main() {
		System.start({title: "Timetask Bug", width: 1024, height: 768}, function (_) {
			Assets.loadEverything(function () {
				
				wWidth = Window.get(0).width;
				wHeight = Window.get(0).height;

				rectWidth = 50;
				rectHeight = 500;
				x = 0;
				y = (wHeight / 2) - (rectHeight / 2);
				speed = 500;

				updateInterval = 1 / 60;
				lastTime = Scheduler.time();
				updateCount = 0;

				Scheduler.addTimeTask(function () { update(); }, 0, updateInterval);
				System.notifyOnFrames(function (frames) { render(frames); });
			});
		});
	}
}
