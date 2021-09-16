this.hate_greenskins_event <- this.inherit("scripts/events/event", {
	m = {
		Image = "",
		Casualty = null
	},
	function create()
	{
		this.m.ID = "event.hate_greenskins";
		this.m.Title = "After the battle...";
		this.m.Cooldown = 25.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%image%{%brother% growls and throws his arms wide like a man overtaken by a primal rage to shed blood.%SPEECH_ON%To hell with those savages! To hell with the greenskins! My life is unfinished so long as they are allowed to walk the same earth as me, my kin, or my children\'s kin! I will rip their tusks from their mouths, ravage their women, I don\'t know if they have women, don\'t know if I\'d go near them if they did actually, but I\'ll ravage something and see to it an annihilation so fierce and thorough the old gods will come to me to borrow a tip!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "That\'s the spirit!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Casualty.getImagePath());
				local trait = this.new("scripts/skills/traits/hate_greenskins_trait");
				_event.m.Casualty.getSkills().add(trait);
				this.List.push({
					id = 10,
					icon = trait.getIcon(),
					text = _event.m.Casualty.getName() + " now hates greenskins"
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

		if (this.Time.getVirtualTimeF() - this.World.Events.getLastBattleTime() > 5.0)
		{
			return;
		}

		local fallen = [];
		local fallen = this.World.Statistics.getFallen();

		if (fallen.len() < 2)
		{
			return;
		}

		if (fallen[0].Time < this.World.getTime().Days || fallen[1].Time < this.World.getTime().Days)
		{
			return;
		}

		if (this.World.Statistics.getFlags().getAsInt("LastCombatFaction") != this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getID() && this.World.Statistics.getFlags().getAsInt("LastCombatFaction") != this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getID())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 3 && !bro.getSkills().hasSkill("trait.fear_greenskins") && !bro.getSkills().hasSkill("trait.hate_greenskins") && !bro.getSkills().hasSkill("trait.dastard") && !bro.getSkills().hasSkill("trait.craven") && !bro.getSkills().hasSkill("trait.fainthearted") && !bro.getSkills().hasSkill("trait.weasel"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Casualty = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 500;
	}

	function onPrepare()
	{
		if (this.World.Statistics.getFlags().getAsInt("LastCombatFaction") == this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getID())
		{
			this.m.Image = "[img]gfx/ui/events/event_81.png[/img]";
		}
		else
		{
			this.m.Image = "[img]gfx/ui/events/event_83.png[/img]";
		}
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"brother",
			this.m.Casualty.getName()
		]);
		_vars.push([
			"image",
			this.m.Image
		]);
	}

	function onClear()
	{
		this.m.Casualty = null;
		this.m.Image = "";
	}

});

