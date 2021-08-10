this.visit_settlements_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.visit_settlements";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "I know the soles of your feet are itchy for the open road, and we need to spread\n word about the company. Let us pay visit to every settlement far and wide!";
		this.m.UIText = "Visit every town and fortification in the world";
		this.m.TooltipText = "Enter each village, city, fortification and castle there is in the world to learn about their goods and services, and spread word about the company.";
		this.m.SuccessText = "[img]gfx/ui/events/event_16.png[/img]You soon discover that the wanderlust of which the skalds sing is not as widespread as they say. Your decision for the band to broaden its horizons is met with grumbling about forced marches and nights on the road. But not all join in the lamenting.%SPEECH_ON%If a day\'s march or a night spent in the rain wears you down, how will you face an orc charge?%SPEECH_OFF%%sergeantbrother% asks the men, only to get a snappish reply.%SPEECH_ON%Dry and alert.%SPEECH_OFF%You cracked the whip though and forced them to it. At each village and town, you encouraged the men to make themselves known, and they take this request to heart, getting in brawls, passing out in the town square, threatening the merchants, and harassing the settlement\'s daughters. Whatever the poor tradesmen and farmers think of the company, at least they won\'t soon forget you! Having traveled to the edges of your map, the name \'%companyname%\' is more widely known, and you earned a better understanding of the land.";
		this.m.SuccessButtonText = "Remember the name, \'%companyname%\'!";
	}

	function getTooltipText()
	{
		if (this.World.Ambitions.getActiveAmbition() == null)
		{
			return this.m.TooltipText;
		}
		else if (!this.onCheckSuccess())
		{
			local ret = this.m.TooltipText + "\n\nThere\'s still some settlements left to visit.\n";
			local c = 0;
			local settlements = this.World.EntityManager.getSettlements();

			foreach( s in settlements )
			{
				if (!s.isVisited())
				{
					c = ++c;

					if (c <= 10)
					{
						ret = ret + ("\n- " + s.getName());
					}
					else
					{
						ret = ret + "\n... and others!";
						break;
					}
				}
			}

			return ret;
		}
		else
		{
			local ret = this.m.TooltipText + "\n\nYou\'ve done what you set out to do.\n";
			return ret;
		}
	}

	function onUpdateScore()
	{
		if (this.World.Ambitions.getDone() == 0 && (this.World.Assets.getOrigin().getID() != "scenario.deserters" || this.World.Assets.getOrigin().getID() != "scenario.raiders"))
		{
			return;
		}

		if (this.World.Ambitions.getDone() < 2)
		{
			return;
		}

		local settlements = this.World.EntityManager.getSettlements();
		local notVisited = 0;

		foreach( s in settlements )
		{
			if (!s.isVisited())
			{
				notVisited = ++notVisited;
			}
		}

		if (notVisited < 4)
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		local settlements = this.World.EntityManager.getSettlements();
		local notVisited = 0;

		foreach( s in settlements )
		{
			if (!s.isVisited())
			{
				notVisited = ++notVisited;
			}
		}

		if (notVisited == 0)
		{
			return true;
		}

		return false;
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local bestBravery = 0;
		local bravest;

		if (brothers.len() > 1)
		{
			for( local i = 0; i < brothers.len(); i = ++i )
			{
				if (brothers[i].getSkills().hasSkill("trait.player"))
				{
					brothers.remove(i);
					break;
				}
			}
		}

		foreach( bro in brothers )
		{
			if (bro.getCurrentProperties().getBravery() > bestBravery)
			{
				bestBravery = bro.getCurrentProperties().getBravery();
				bravest = bro;
			}
		}

		_vars.push([
			"sergeantbrother",
			bravest.getName()
		]);
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
	}

});

