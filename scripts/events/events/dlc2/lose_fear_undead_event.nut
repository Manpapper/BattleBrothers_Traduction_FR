this.lose_fear_undead_event <- this.inherit("scripts/events/event", {
	m = {
		Casualty = null,
		Other = null
	},
	function create()
	{
		this.m.ID = "event.lose_fear_undead";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 25.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]{%fearful% interrompt une pause de la compagnie avec un discours soudain.%SPEECH_ON%J\'ai tué et enterré tellement d\'hommes, vous savez ? Et s\'ils valaient leur pesant d\'or, ils n\'auraient pas eu l\'occasion de revenir en tant que morts-vivants pour commencer ! Et s\'ils reviennent des temps anciens, que je sois damné, ils sont tenaces ! Mais ce n\'est pas moi. Je suis vivant. Je respire. Et je veux que ça reste comme ça. Et quand mon heure sera venue, j\'essaierai de rester mort, parce que j\'ai le courage de savoir que j\'ai assez perturbé ce monde.%SPEECH_OFF%En applaudissant, %otherbrother% offre une assiette de nourriture.%SPEECH_ON%Bon d\'accord, maintenant arrête de nous déranger !%SPEECH_OFF%Les hommes rient et %fearful% se joint à eux.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ce monde appartient aux vivants.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Casualty.getImagePath());
				local trait = _event.m.Casualty.getSkills().getSkillByID("trait.fear_undead");
				this.List.push({
					id = 10,
					icon = trait.getIcon(),
					text = _event.m.Casualty.getName() + " n\'a plus peur des morts-vivants"
				});
				_event.m.Casualty.getSkills().remove(trait);
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (this.World.Statistics.getFlags().getAsInt("LastCombatFaction") != this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID() && this.World.Statistics.getFlags().getAsInt("LastCombatFaction") != this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies).getID())
		{
			return;
		}

		if (this.Time.getVirtualTimeF() - this.World.Events.getLastBattleTime() > this.World.getTime().SecondsPerDay * 1.0)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates = [];
		local candidates_other = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (!bro.getSkills().hasSkill("trait.fear_undead") || bro.getLifetimeStats().Battles < 25 || bro.getLifetimeStats().Kills < 50 || bro.getLifetimeStats().BattlesWithoutMe != 0)
			{
				candidates_other.push(bro);
			}
			else
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0 || candidates_other.len() == 0)
		{
			return;
		}

		this.m.Casualty = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Other = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];
		this.m.Score = this.m.Casualty.getLifetimeStats().Kills / 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"fearful",
			this.m.Casualty.getName()
		]);
		_vars.push([
			"otherbrother",
			this.m.Other.getName()
		]);
	}

	function onClear()
	{
		this.m.Casualty = null;
		this.m.Other = null;
	}

});

