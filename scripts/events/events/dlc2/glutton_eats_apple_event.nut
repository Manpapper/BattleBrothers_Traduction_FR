this.glutton_eats_apple_event <- this.inherit("scripts/events/event", {
	m = {
		Glutton = null,
		Other = null
	},
	function create()
	{
		this.m.ID = "event.glutton_eats_apple";
		this.m.Title = "During camp...";
		this.m.Cooldown = 60.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_18.png[/img]{You come to a commotion between %glutton% the glutton and a bucket. He\'s heaving into it so hard his back lurches like a cat and his hurls sound like an undead cow giving birth. When he lifts his head his face looks like a gourd, cheeks ballooned, his mouth still all agargle. %otherbrother% comes over.%SPEECH_ON%He ate the witch\'s apple.%SPEECH_OFF%Raising an eyebrow, you ask the glutton why he would do such a thing. Vomit strings wriggle from his wrist as he wipes his eyes.%SPEECH_ON%{Cause I\'m always hungr-hurgh, uh, hungregghhh! | I don\'t rightfully know sir can\'t I just be in pain without having to validate my actiiiherrrghh! | Would I have to explain myself if I wasn\'t losing my gouerrrghhhh! | Cause you told me to eat healthy and it was an apperrrghghh!}%SPEECH_OFF%He pitches his head back into the bucket like a man who dropped a million crowns down a well. You tell the mercenaries to keep an eye on him until it\'s all out of his system, that is if it ever will be.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Why...?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Glutton.getImagePath());
				local stash = this.World.Assets.getStash().getItems();

				foreach( i, item in stash )
				{
					if (item != null && item.getID() == "misc.poisoned_apple")
					{
						stash[i] = null;
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = "You lose " + item.getName()
						});
						break;
					}
				}

				local effect = this.new("scripts/skills/injury/sickness_injury");
				_event.m.Glutton.getSkills().add(effect);
				this.List.push({
					id = 10,
					icon = effect.getIcon(),
					text = _event.m.Glutton.getName() + " is sick"
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

		local candidates_glutton = [];
		local candidates_other = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getSkills().hasSkill("trait.gluttonous"))
			{
				candidates_glutton.push(bro);
			}
			else
			{
				candidates_other.push(bro);
			}
		}

		if (candidates_glutton.len() == 0 || candidates_other.len() == 0)
		{
			return;
		}

		local stash = this.World.Assets.getStash().getItems();
		local hasItem = false;

		foreach( item in stash )
		{
			if (item != null && item.getID() == "misc.poisoned_apple")
			{
				hasItem = true;
				break;
			}
		}

		if (!hasItem)
		{
			return;
		}

		this.m.Glutton = candidates_glutton[this.Math.rand(0, candidates_glutton.len() - 1)];
		this.m.Other = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];
		this.m.Score = candidates_glutton.len() * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"glutton",
			this.m.Glutton.getName()
		]);
		_vars.push([
			"otherbrother",
			this.m.Other.getName()
		]);
	}

	function onClear()
	{
		this.m.Glutton = null;
		this.m.Other = null;
	}

});

