this.gladiators_vibes_event <- this.inherit("scripts/events/event", {
	m = {
		Gladiator1 = null,
		Gladiator2 = null
	},
	function create()
	{
		this.m.ID = "event.gladiators_vibes";
		this.m.Title = "During camp...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_155.png[/img]{%gl1% watches %gl2% pluck at his eyebrows, using the sheen of his weapons blade for a mirror.%SPEECH_ON%Your back is looking thick and tight, %gl2%. Das it, mane.%SPEECH_OFF%The gladiator turns around and nods.%SPEECH_ON%Thanks, I use it to carry this company.%SPEECH_OFF% | %SPEECH_ON%Form check! Form check!%SPEECH_OFF%%gl1% is in mid-squat as he yells out. %gl2% rushes over and palms the gladiator\'s buttocks and yells \'go!\'. The man dips the squat far past ninety degrees.%SPEECH_ON%It\'s tight!%SPEECH_OFF%%gl2% confirms.%SPEECH_ON%How tight?%SPEECH_OFF%%gl2% takes a hand back, balls into a fist, and punches the man\'s ass. He then flails his hand back and forth like it touched a hot pan.%SPEECH_ON%Tighter than a Vizier\'s purse!%SPEECH_OFF%%gl1% finishes his squat and stands up and they chest bump.%SPEECH_ON%Your turn, man! Let\'s gooo!%SPEECH_OFF% | %SPEECH_ON%Hey. Look at this.%SPEECH_OFF%%gl1%\'s chest bounces, one boob at a time. You tell him \'nice boobs\' and move on, but he grabs you.%SPEECH_ON%They\'re not boobs, they\'re pecs. And they\'re beautiful. Hey. Say they\'re beautiful.%SPEECH_OFF%One tit bumps, and then the other, back and forth. Sighing, you say they\'re beautiful. %gl1% nods and wipes something from his eye.%SPEECH_ON%Thanks, captain.%SPEECH_OFF% | You find %gl1% bench pressing %gl2%, the latter reading from a scroll as he goes up and down.%SPEECH_ON%%randomcitystate% is said to have beautiful women.%SPEECH_OFF%He looks back at the man lifting him. %gl1% glances at you, then back to his workout.%SPEECH_ON%Ninety-eight. Ninety-nine. One hundred! Alright, flip over.%SPEECH_OFF%%gl2% rolls over, %gl1%\'s hands puttying into his chest and belly.%SPEECH_ON%Alright, one-hundred more reps.%SPEECH_OFF% | %gl1% holds up four fingers. %gl2% holds up six. Cocking his head, %gl1% laughs.%SPEECH_ON%In one night?%SPEECH_OFF%The other gladiator nods.%SPEECH_ON%Yessir. In one night.%SPEECH_OFF%%gl1% laughs and asks if they were all women. %gl2% hesitates.%SPEECH_ON%Well, there were a couple men there. But we didn\'t like, you know, touch or anything. We got close though, cause at one point he was down there, and I was positioned like this behind-%SPEECH_OFF%You walk over clapping, not in applause but to tell the gladiators to stay focused. You understand the roads can be long and boring, but this is getting ridiculous. | %gl1% flexes his biceps.%SPEECH_ON%I could snap a mule\'s neck with one arm.%SPEECH_OFF%Shaking his head, %gl2% asks why he\'s flexing both arms then. %gl1% cocks his head in return.%SPEECH_ON%Well obviously I plan to kill two mules at the same time, man.%SPEECH_OFF%You interrupt, telling the gladiators they won\'t be killing any animals until they complete the %companyname%\'s primary tasks which is only sometimes to kill animals. | %gl1% sits beside %gl2% and turns away. He says.%SPEECH_ON%Put your hand on my spine. Right between the shoulders.%SPEECH_OFF%The other gladiator obliges without question or curiosity. In turn, %gl1% flexes, trapping the man\'s hand between two masses of muscle.%SPEECH_ON%How do you like that power?%SPEECH_OFF%Again, without a hint of irony or incredulity, %gl2% obliges a response.%SPEECH_ON%It is awesome, man! I can hear my hand bones cracking!%SPEECH_OFF%You think to interrupt, but technically nobody is hurt... yet. You leave the gladiators to their, eh, proclivities. | %SPEECH_START%So I got her over the fruit cart like this and we\'re just having a grand old time when her father walks in. He stands all slackjawed and can hardly get a word out.%SPEECH_OFF%%gl1% nods.%SPEECH_ON%So I says to him, watch this. And I stand back and flex with both arms and slowly, ever so slowly, she lifts up off the ground.%SPEECH_OFF%%gl2% slaps the other gladiator in his glistening chest.%SPEECH_ON%You lie! That\'s a buncha lies!%SPEECH_OFF%The gladiator holds his hand up.%SPEECH_ON%By the light of the Gilder, and whatever other gods may deem to gawk at my body, it is the truth. My pole has power.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Good for you.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Gladiator1.getImagePath());
				this.Characters.push(_event.m.Gladiator2.getImagePath());
				_event.m.Gladiator1.improveMood(1.0, "Feels strong and beautiful");

				if (_event.m.Gladiator1.getMoodState() > this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Gladiator1.getMoodState()],
						text = _event.m.Gladiator1.getName() + this.Const.MoodStateEvent[_event.m.Gladiator1.getMoodState()]
					});
				}

				_event.m.Gladiator2.improveMood(1.0, "Feels strong and beautiful");

				if (_event.m.Gladiator2.getMoodState() > this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Gladiator2.getMoodState()],
						text = _event.m.Gladiator2.getName() + this.Const.MoodStateEvent[_event.m.Gladiator2.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_155.png[/img]{%gl1% bursts into your tent.%SPEECH_ON%Captain! Quick, %gl2% needs help!%SPEECH_OFF%You rush out of the tent and find %gl2% sitting before the campfire. He\'s practically shaking. %gl1% tells you the man had a nightmare.%SPEECH_ON%He dreamt that he was a man so scrawny he could hardly lift a basket of apples. Women spat at him. Children ran from him in fear. And he went to the arenas, except he had to sit in the stands!%SPEECH_OFF%%gl2% looks up sorrowfully.%SPEECH_ON%They weren\'t even good seats, captain. They weren\'t even good seats.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "It was just a bad dream.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Gladiator1.getImagePath());
				this.Characters.push(_event.m.Gladiator2.getImagePath());
				_event.m.Gladiator2.worsenMood(1.0, "Had a bad dream about not being strong and beautiful");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Gladiator2.getMoodState()],
					text = _event.m.Gladiator2.getName() + this.Const.MoodStateEvent[_event.m.Gladiator2.getMoodState()]
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.gladiators")
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.gladiator" && bro.getFlags().get("IsPlayerCharacter"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() < 2)
		{
			return;
		}

		local r = candidates.len() - 1;
		this.m.Gladiator1 = candidates[r];
		candidates.remove(r);
		local r = candidates.len() - 1;
		this.m.Gladiator2 = candidates[r];
		this.m.Score = 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"gl1",
			this.m.Gladiator1 != null ? this.m.Gladiator1.getName() : ""
		]);
		_vars.push([
			"gl2",
			this.m.Gladiator2 != null ? this.m.Gladiator2.getName() : ""
		]);
	}

	function onDetermineStartScreen()
	{
		if (this.Math.rand(1, 100) <= 90)
		{
			return "A";
		}
		else
		{
			return "B";
		}
	}

	function onClear()
	{
		this.m.Gladiator1 = null;
		this.m.Gladiator2 = null;
	}

});

