this.anatomist_joins_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_joins";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_184.png[/img]{A man in drab, grey garb approaches. In place of weapons and armor, he has scrolls and papers with him, as well as a bandolier of vials and pouches brimming with strange flesh and fur. He hails you.%SPEECH_ON%Ah, the %companyname%. I have been looking for men of such...qualities. You see, I am an anatomist and-%SPEECH_OFF%You stop him right there. You\'ve little time for men who obsess over strange fascinations. Either he wants to join or not, and you tell him that tersely. | You come across a man who is kneeling over a dead dog. He probes the snout with a long stick and nods.%SPEECH_ON%As you can tell, I am a famed anatomist.%SPEECH_OFF%Turning his head up like some creepy puppet, he claims that the %companyname% is slowly becoming renowned for its studious work - and that he wishes to join. | You find a coat, pants, and a pair of boots on a rock. Beside it are some bandoliers and reams of paper and bizarre drawings. Looking out, you see a pond and a man frolicking in it. He jolts at the sight of you and points a finger.%SPEECH_ON%Don\'t touch that! Hey you, don\'t touch anything!%SPEECH_OFF%He gets up out of the water, his legs awkwardly splish-splashing through the surface. As he rises up out of the pond you see that, thankfully, he\'s absurdly hairy in parts, the water turning his hairy crotch into some grey felt loincloth. You draw your sword and the man comes to a stop.%SPEECH_ON%Hold that steel, traveler. I see now that you are of an inquisitive mind and so am I! And, my dear steel-driven traveler, I am in dire need of need of equals. What say you that I join?%SPEECH_OFF%You try to keep your eyes above the neck, but a stiff wind blows through and you can hear water flying off his crotch like a shaking wet dog. The glance down which follows is quite unfortunate. | You come across a man sitting on a rock. Across from him is a slab of stone layered with dissected animals. Puppies, kittens, what might be a frog, some sort of rodent, and...a duck. He jumps to his feet.%SPEECH_ON%Behold, traveler, the result of my studies. Yet I am still short on so many of my studies. I can see that you are of an inquisitive mind albeit no doubt a brute. I would like to offer my services to you, though, I must warn, the advances I have made with these are for me and me alone.%SPEECH_OFF%He protectively holds an arm ahead of the dissected animals as if you\'d have any interest with them.}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Yes, we\'ll take you.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "We don\'t need your help.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"anatomist_background"
				]);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_184.png[/img]{The man briefly bows.%SPEECH_ON%Ahh, it is good to be with my intellectual equals, though I shall remind them that there are some more equal than others, and if they wish to read my works they may submit a request to do so.%SPEECH_OFF%Yeah. Sure.}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Just get in the wagon.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_184.png[/img]{The man nods.%SPEECH_ON%Fair enough. I know that when I came across my intellectual superior, I grew jealous and refused any help he provided. Well, good sir, may you travel well and catch up to me and my discoveries!%SPEECH_OFF%}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Yeah, fark you, too.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.anatomists")
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local numAnatomists = 0;

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				numAnatomists++;
			}
		}

		local comebackBonus = numAnatomists < 3 ? 8 : 0;
		this.m.Score = 2 + comebackBonus;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});

