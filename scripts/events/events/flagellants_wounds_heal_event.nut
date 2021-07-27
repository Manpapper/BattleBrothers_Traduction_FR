this.flagellants_wounds_heal_event <- this.inherit("scripts/events/event", {
	m = {
		Flagellant = null
	},
	function create()
	{
		this.m.ID = "event.flagellants_wounds_heal";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 70.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_39.png[/img]%flagellant% the flagellant is found sitting cross-legged before a campfire. He\'s all alone save the millmoths fluttering dangerously close to the flames. Sensing your presence, he calls you over. You take a seat beside him and he smiles at you.%SPEECH_ON%I\'ve become a better man since joining this company.%SPEECH_OFF%You nod as he surely has. He continues.%SPEECH_ON%I\'ve bled for the gods a great deal, but my wounds... they are but scars now. I feel stronger than ever.%SPEECH_OFF%Again you nod, but then quickly ask if he is going to stop hurting himself. The man\'s eyes stare into the red-brimming embers. He shakes his head no.%SPEECH_ON%I will bleed for the gods until they say no more.%SPEECH_OFF%Wondering aloud, you ask if the gods have spoken to him at all. Without a pause the man shakes his head no again.%SPEECH_ON%They have not and so I shall bleed until their silence is broken or until I join them in the forever quiet.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "So time does heal all wounds, then.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Flagellant.getImagePath());
				local hitpoints = this.Math.rand(4, 6);
				_event.m.Flagellant.getBaseProperties().Hitpoints += hitpoints;
				_event.m.Flagellant.getSkills().update();
				_event.m.Flagellant.getFlags().add("wounds_scarred_over");
				this.List = [
					{
						id = 17,
						icon = "ui/icons/health.png",
						text = _event.m.Flagellant.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + hitpoints + "[/color] Hitpoints"
					}
				];
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidate_flagellant = [];

		foreach( bro in brothers )
		{
			if (bro.getFlags().has("wounds_scarred_over"))
			{
				continue;
			}

			if (bro.getLevel() < 6)
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.flagellant" || bro.getBackground().getID() == "background.monk_turned_flagellant")
			{
				candidate_flagellant.push(bro);
			}
		}

		if (candidate_flagellant.len() == 0)
		{
			return;
		}

		this.m.Flagellant = candidate_flagellant[this.Math.rand(0, candidate_flagellant.len() - 1)];
		this.m.Score = candidate_flagellant.len() * 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"flagellant",
			this.m.Flagellant.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Flagellant = null;
	}

});

