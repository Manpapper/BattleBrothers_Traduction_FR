this.gain_addiction_event <- this.inherit("scripts/events/event", {
	m = {
		Addict = null,
		Other = null
	},
	function create()
	{
		this.m.ID = "event.gain_addiction";
		this.m.Title = "During camp...";
		this.m.Cooldown = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_12.png[/img]{Shouting and hollering, %other% drags %addict% into your tent, drops him, and draws his weapon on the man who looks around dazed and confused. You demand to know what is going on. %addict% slaps the weapon out of his face and tries to get up, but %other% kicks him back down.%SPEECH_ON%Fellas got it rich for the potions, captain. We can hardly keep him away from the stock.%SPEECH_OFF%Addict slurs his words, grunts and pauses, then nods. He speaks clearly, like a drunkard trying to explain his crime to the constable.%SPEECH_ON%I do not have a problem, sir.%SPEECH_OFF%You get up and check the man\'s forehead. It is cold, yet drawing sweat. %other% spits.%SPEECH_ON%He\'ll get a smidge violent if you confront him about the potions, sir. I think he\'s addicted to the damned things.%SPEECH_OFF%You nod and tell the two to keep it on level to the best of their abilities. | %addict% comes into your tent with sweat on his brow and blackeyes.%SPEECH_ON%Sir, I thought I\'d tell you this personally, you know, to take full responsibility.%SPEECH_OFF%He explains that he has become addicted to the potions. He says he\'ll do his best to manage. You nod and thank him for his honesty. The news worries you, but there is little recourse as of yet. | The men explain that %addict% has strongly taken to the potions and vials and flasks, the ones that carry spirits beyond just good ale and mead. You\'re not sure if it\'s from overuse or because he is having difficulty handling the struggles of being a sellsword. A few of the men are told to keep an eye on him. It\'s the best you can do for now.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "The road takes its toll, but can the men manage?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Addict.getImagePath());
				local trait = this.new("scripts/skills/traits/addict_trait");
				_event.m.Addict.getSkills().add(trait);
				this.List.push({
					id = 10,
					icon = trait.getIcon(),
					text = _event.m.Addict.getName() + " is now an addict"
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates_addict = [];
		local candidates_other = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getFlags().get("PotionsUsed") >= 4 && this.Time.getVirtualTimeF() - bro.getFlags().get("PotionLastUsed") <= 3.0 * this.World.getTime().SecondsPerDay)
			{
				candidates_addict.push(bro);
			}
			else
			{
				candidates_other.push(bro);
			}
		}

		if (candidates_addict.len() == 0 || candidates_other.len() == 0)
		{
			return;
		}

		this.m.Addict = candidates_addict[this.Math.rand(0, candidates_addict.len() - 1)];
		this.m.Other = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];
		this.m.Score = 5 + candidates_addict.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"addict",
			this.m.Addict.getName()
		]);
		_vars.push([
			"other",
			this.m.Other.getName()
		]);
	}

	function onClear()
	{
		this.m.Addict = null;
		this.m.Other = null;
	}

});

