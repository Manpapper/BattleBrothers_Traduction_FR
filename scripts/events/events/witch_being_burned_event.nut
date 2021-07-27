this.witch_being_burned_event <- this.inherit("scripts/events/event", {
	m = {
		Witchhunter = null,
		Townname = null
	},
	function create()
	{
		this.m.ID = "event.witch_being_burned";
		this.m.Title = "À %townname%";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_79.png[/img]{You stroll into %townname% just in time to see a smoldering body keel forward from the blackened stake onto which they were tied. A few citizens pass you, cheering the death of a witch. Curious as to whether or not this was true, your very own witchhunter, %witchhunter%, goes to the body and examines it. With a sigh, he looks back at you and shakes his head. | %townname% welcomes you with horrifying screams. Three of its citizens are in the town center being burned alive. The fires grow beneath them until the flames come licking their feet, then crawling up their legs, drawing them to cry out for mercy to which the crowds responds by throwing rocks.\n\nYou about draw your sword to end this injustice when %witchhunter_short% the witchhunter stays your hand. He shakes his head and points at the burnings. Soon enough, the begging stops and all three victims open their mouths, issuing forth a rumbling that silences the crowd and even the crackle of fire beneath them. They speak in a guttural, uniform voice.%SPEECH_ON%Ye who watches us perish, shall perish themselves!%SPEECH_OFF%The bodies suddenly slump forward as though instantly made dead and the cooking of their flesh resumes with a steady popping. The witchhunter orders your men to look away, which you quickly do, and behind you comes renewed screams, but this time from the townspeople themselves. You shant forget this moment anytime soon.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "What is this...?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local playerTile = this.World.State.getPlayer().getTile();
		local foundTown = false;

		foreach( t in towns )
		{
			if (t.isMilitary() || t.isSouthern() || t.getSize() > 2)
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
			{
				foundTown = true;
				this.m.Townname = t.getNameOnly();
				break;
			}
		}

		if (!foundTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local witchhunter_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.witchhunter")
			{
				witchhunter_candidates.push(bro);
			}
		}

		if (witchhunter_candidates.len() == 0)
		{
			return;
		}

		this.m.Witchhunter = witchhunter_candidates[this.Math.rand(0, witchhunter_candidates.len() - 1)];
		this.m.Score = 25;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"witchhunter",
			this.m.Witchhunter.getName()
		]);
		_vars.push([
			"witchhunter_short",
			this.m.Witchhunter.getNameOnly()
		]);
		_vars.push([
			"townname",
			this.m.Townname
		]);
	}

	function onClear()
	{
		this.m.Witchhunter = null;
		this.m.Townname = "";
	}

});

