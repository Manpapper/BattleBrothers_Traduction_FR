this.hate_undead_event <- this.inherit("scripts/events/event", {
	m = {
		Image = "",
		Casualty = null
	},
	function create()
	{
		this.m.ID = "event.hate_undead";
		this.m.Title = "After the battle...";
		this.m.Cooldown = 25.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%image%{%%brother% crache et passe sa main sous son nez. Son visage se renfrogne et il semble se parler à lui-même sous le regard des autres.%SPEECH_ON%Les vieux dieux auront nos culs si nous permettons aux morts de marcher à nouveau ! Vous pouvez aller dans l\'au-delà en pensant avoir fait le bien dans ce monde, mais je ne suivrai pas la route de l\'oisiveté, car à mon avis, cette route mène droit aux enfers. Je veillerai à ce que ma fin soit juste, et je le ferai en tuant tous les morts-vivants que je verrai !%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C\'est ça l\'esprit !",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Casualty.getImagePath());
				local trait = this.new("scripts/skills/traits/hate_undead_trait");
				_event.m.Casualty.getSkills().add(trait);
				this.List.push({
					id = 10,
					icon = trait.getIcon(),
					text = _event.m.Casualty.getName() + " déteste maintenant les morts-vivants"
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

		if (this.Time.getVirtualTimeF() - this.World.Events.getLastBattleTime() > 8.0)
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

		if (this.World.Statistics.getFlags().getAsInt("LastCombatFaction") != this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID() && this.World.Statistics.getFlags().getAsInt("LastCombatFaction") != this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies).getID())
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
			if (bro.getLevel() >= 3 && !bro.getSkills().hasSkill("trait.fear_undead") && !bro.getSkills().hasSkill("trait.hate_undead") && !bro.getSkills().hasSkill("trait.dastard") && !bro.getSkills().hasSkill("trait.craven") && !bro.getSkills().hasSkill("trait.fainthearted") && !bro.getSkills().hasSkill("trait.weasel"))
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
		this.m.Image = "[img]gfx/ui/events/event_46.png[/img]";
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

