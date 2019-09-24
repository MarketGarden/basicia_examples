package runner.runner.speedy;

import kha.Color;
import iron.object.Object;
import iron.math.Vec4;
import armory.trait.physics.RigidBody;
import basicia.definitions.IState;
import iron.Scene;
import runner.RunnerHelper;

#if arm_debug
import vdebug.VDebug;
#end
import Std;

class TrainSceneTrait extends basicia.iron.WebSocketEnvTrait {
	
	private var total:Float = 0; //TODO Design : move WebSocketEnvTrait
	private var win:Int = 0; //TODO Design : move WebSocketEnvTrait
	private var loose:Int = 0; //TODO Design : move WebSocketEnvTrait

	private var rb:RigidBody;
	private var population = new Array<Object>();
	private var target:Object;

	public function new() {
		super();
	}

	public override function step(commands:Array<Float>):IState {
		var action = new MyEnvActions(target, rb);
		var fairplay = action.Apply(commands);
		
		var velocity = rb.getLinearVelocity().length();
		total += velocity;

		var state = new MyEnvState(this.target, rb, total, fairplay);

		if (state.done) {
			if (fairplay) {
				this.win++;
			} else {
				this.loose++;
			}
		}

		#if arm_debug
		
		VDebug.variable("Ok", this.win + "#");
		VDebug.variable("KO", this.loose + "#");
		VDebug.message("----------------------------");
		state.debug();
		var color = Color.fromFloats(0, state.reward, 0);
		VDebug.trail(this.target.transform.world.getLoc(), color, 3, "target", 200);
		VDebug.point(new Vec4(0, 0, 0), Color.White, 6);
		#end

		return state;
	}

	public override function reset():IState {
		total = 0;
		RunnerHelper.shufflePopulation(this.population);
		return new MyEnvState(this.target, rb, total, true);
	}

	public override function init():Void {
		this.population = RunnerHelper.getPopulation();
		for (o in this.population) {
			o.addTrait(new RandomMoveTrait());
			o.addTrait(new AutoRotateTrait());
		}
		
		this.target = Scene.active.getChild("Cube.000");

		this.population.push(this.target);

		this.rb = this.target.getTrait(RigidBody);
	}


}
