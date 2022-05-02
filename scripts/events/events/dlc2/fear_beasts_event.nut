this.fear_beasts_event <- this.inherit("scripts/events/event", {
	m = {
		Casualty = null
	},
	function create()
	{
		this.m.ID = "event.fear_beasts";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 25.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]{%%brother% sculpte un lapin dans un morceau d\'écorce. Tout se passe bien jusqu\'à ce qu\'il jette rageusement le tout dans le feu de camp.%SPEECH_ON%Oh, de qui je me moque ? J\'aimerais être ici pour chasser du gibier ! Mais ce n\'est pas du gibier, ce sont des monstres ! Des créatures de la nuit ! Des conneries, tout ça, d\'où est-ce qu\'ils viennent ? Eh bien je vais vous dire, je ne vais pas me faire tuer par une de ces choses ! Pas la moindre chance !%SPEECH_OFF%Le reste de la compagnie le dévisage alors qu\'il se remet de son accès de colère. Il regarde tranquillement le lapin sculpter se brûler et se consummer.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Cela a des conséquences sur les hommes.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Casualty.getImagePath());
				local trait = this.new("scripts/skills/traits/fear_beasts_trait");
				_event.m.Casualty.getSkills().add(trait);
				this.List.push({
					id = 10,
					icon = trait.getIcon(),
					text = _event.m.Casualty.getName() + " a maintenant peur des bêtes"
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

		if (this.World.Statistics.getFlags().getAsInt("LastCombatFaction") != this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID())
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
			if (bro.getBackground().getID() == "background.companion" || bro.getBackground().getID() == "background.beast_slayer" || bro.getBackground().getID() == "background.hunter" || bro.getBackground().getID() == "background.witchhunter" || bro.getBackground().getID() == "background.wildman")
			{
				continue;
			}

			if (bro.getLevel() <= 7 && !bro.getSkills().hasSkill("trait.fear_beasts") && !bro.getSkills().hasSkill("trait.hate_beasts") && !bro.getSkills().hasSkill("trait.fearless") && !bro.getSkills().hasSkill("trait.brave") && !bro.getSkills().hasSkill("trait.determined") && !bro.getSkills().hasSkill("trait.bloodthirsty"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Casualty = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 50;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"brother",
			this.m.Casualty.getName()
		]);
	}

	function onClear()
	{
		this.m.Casualty = null;
	}

});

