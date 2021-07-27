this.wound_gets_infected_event <- this.inherit("scripts/events/event", {
	m = {
		Injured = null,
		Other = null,
		WoundName = ""
	},
	function create()
	{
		this.m.ID = "event.wound_gets_infected";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_34.png[/img]{You discover %woundedbrother% passed out in the grass and there\'s no mead or ale beside him as a sort of coma culprit. Crouching down, you see that his eyes are dimmed and he does not respond to questions. His chest rises and falls to uneven breathing. You peel back the dressings over his %wound% to reveal green, sickly flesh. | %woundedbrother% is laughing with the rest of the men when he suddenly falls over with his eyes going to the back of his head. The rest of the men rush to his aid.%SPEECH_ON%Sir, his wound\'s beyond sore.%SPEECH_OFF%The flesh around his %wound% has gotten pulpy, slathered with dead skin and the pulsing viridian of infections ready to be sloughed off. | %woundedbrother%\'s %wound% has gotten infected. The flesh around the injury is black and that which has color is green, both very bad signs. | Infection is settling into %woundedbrother%\'s %wound%. There\'s no saying if he\'ll survive or not, but either way he\'s going to be in bad shape for a time. | You come to find %woundedbrother% leaning against a tree. He\'s shaking and saliva is dropping from his lips.%SPEECH_ON%I\'m alright, sir. My %wound%\'s just... a little infected. Give me time, I\'ll get better.%SPEECH_OFF%You purse your lips. Perhaps he\'ll get better on his own, but he\'ll be hardly in fighting shape if he goes without care. | %woundedbrother% is no longer in sound fighting shape. His wounds have gotten infected. Without immediate care, it may take some time for him to get back into fighting shape. | %woundedbrother% stumbles into your tent. He coughs into the crook of his elbow and a stringy bit of saliva trails between it and his lips.%SPEECH_ON%Ah shit, sorry sir. I\'m uh, I think I\'m a little sick.%SPEECH_OFF%Taking a look at him, you surmise that his wounds have gotten infected. He may still be able to fight, but you probably shouldn\'t risk that until he gets better. | While the company eats around a campfire, %woundedbrother% suddenly vomits. You see that there\'s sweat all over his brow and his eyes are a bit dazed. %otherbrother% shakes his head.%SPEECH_ON%Sir, his wounds have gotten infected.%SPEECH_OFF%The wounded brother sails back into the grass, arms pawing the air.%SPEECH_ON%I\'m fine, ya gits. I\'ll fight the lot of you.%SPEECH_OFF%His balled fists pedal back and forth before he slides into a deep sleep. Yeah, he\'s probably not gonna be battle ready for awhile. | Battles take a toll on men, and sometimes they survive wounds that come back to get them. %woundedbrother% is such a man - infection from injuries has spread about his body. He\'s very sick and should not fight unless absolutely necessary. | With each battle, a man risks death. With each injury, he risks infection. %woundedbrother% has received the latter and it just may preempt the former. His wounds have become black and where they aren\'t black they are green. He\'s able to walk, but should probably be kept out of the frontlines until he gets better. | A man may survive a battle with terrible wounds, but it only starts another battle against infection. %woundedbrother%\'s injuries have gotten worse and may need time to heal. Unless absolutely necessary, he should be kept out of the frontlines. | %woundedbrother%\'s injuries have gotten worse, possibly infected. Some suggest maggots to help clear out the infection, while others hint at amputations and more drastic measures. As far as you\'re concerned, you simply need to give it time. That said, the mercenary should probably be kept out of the fights until he gets better.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "{Hope you\'ll pull through. | That doesn\'t look good. | Go get some rest, %woundedbrothershort%.}",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Injured.getImagePath());
				local injury = _event.m.Injured.addInjury([
					{
						ID = "injury.infection",
						Threshold = 0.25,
						Script = "injury/infected_wound_injury"
					}
				]);
				this.List = [
					{
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.Injured.getName() + " suffers " + injury.getNameOnly()
					}
				];
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			local injuries = bro.getSkills().query(this.Const.SkillType.TemporaryInjury);
			local next = false;

			foreach( inj in injuries )
			{
				if (inj.getID() == "injury.infection")
				{
					next = true;
					break;
				}
			}

			if (next)
			{
				continue;
			}

			foreach( inj in injuries )
			{
				if (!inj.isTreated() && inj.getInfectionChance() != 0)
				{
					candidates.push(bro);
				}
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Injured = candidates[this.Math.rand(0, candidates.len() - 1)];

		do
		{
			this.m.Other = brothers[this.Math.rand(0, brothers.len() - 1)];
		}
		while (this.m.Other.getID() == this.m.Injured.getID());

		this.m.Score = candidates.len() * 7;
	}

	function onPrepare()
	{
		local injuries = this.m.Injured.getSkills().query(this.Const.SkillType.TemporaryInjury);
		local wound;
		local highest = -1.0;

		foreach( inj in injuries )
		{
			if (!inj.isTreated() && inj.getInfectionChance() > highest)
			{
				wound = inj;
				highest = inj.getInfectionChance();
			}
		}

		this.m.WoundName = wound.getNameOnly().tolower();
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"wound",
			this.m.WoundName
		]);
		_vars.push([
			"woundedbrother",
			this.m.Injured.getName()
		]);
		_vars.push([
			"woundedbrothershort",
			this.m.Injured.getNameOnly()
		]);
		_vars.push([
			"otherbrother",
			this.m.Other.getName()
		]);
	}

	function onClear()
	{
		this.m.Injured = null;
		this.m.Other = null;
		this.m.WoundName = "";
	}

});

