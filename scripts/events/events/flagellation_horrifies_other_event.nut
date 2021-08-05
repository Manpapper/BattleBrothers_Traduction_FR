this.flagellation_horrifies_other_event <- this.inherit("scripts/events/event", {
	m = {
		Flagellant = null,
		OtherGuy = null
	},
	function create()
	{
		this.m.ID = "event.flagellation_horrifies_other";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 45.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_38.png[/img]La chair déchirée en morceaux. Des parties de l\'homme rendues méconnaissables. Une odeur de cuivre dans l\'air. Ce sont les choses que l\'on trouve quand on est attiré par l\'appel d\'un frère d\'armes.\n\n %flagellant% le flagellant, courbé sur une souche, le corps immobile à l\'exception de son bras qui fait claquer un fouet de verre et d\'épines contre son propre dos. Un gargouillement attire votre attention sur %weakbro% qui est courbé dans les hautes herbes en train de perdre son déjeuner. Sentant qu\'il dérange les autres, %flagellant% esquisse une sorte de sourire qui ne cède en rien à l\'horreur qu\'il commet sur sa propre peau.%SPEECH_ON%Ne crains pas la faucheuse, %weakbro%, je saignerai encore plus pour sauver ton âme.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "{Une étrange coutume. | Ça ne peut pas être sain.}",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Flagellant.getImagePath());
				this.Characters.push(_event.m.OtherGuy.getImagePath());
				_event.m.OtherGuy.worsenMood(1.0, "Horrifié par la flagelation de " + _event.m.Flagellant.getName());

				if (_event.m.OtherGuy.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.OtherGuy.getMoodState()],
						text = _event.m.OtherGuy.getName() + this.Const.MoodStateEvent[_event.m.OtherGuy.getMoodState()]
					});
				}

				_event.m.Flagellant.improveMood(1.0, "Satisfait par sa flagelation");

				if (_event.m.Flagellant.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Flagellant.getMoodState()],
						text = _event.m.Flagellant.getName() + this.Const.MoodStateEvent[_event.m.Flagellant.getMoodState()]
					});
				}

				if (this.Math.rand(1, 100) <= 50)
				{
					local injury = _event.m.Flagellant.addInjury(this.Const.Injury.Flagellation);
					this.List.push({
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.Flagellant.getName() + " souffre de " + injury.getNameOnly()
					});
				}
				else
				{
					_event.m.Flagellant.addLightInjury();
					this.List.push({
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Flagellant.getName() + " souffre de blessures légères"
					});
				}
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

		local candidate_flagellant = [];

		foreach( bro in brothers )
		{
			if ((bro.getBackground().getID() == "background.flagellant" || bro.getBackground().getID() == "background.monk_turned_flagellant") && !bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
			{
				candidate_flagellant.push(bro);
			}
		}

		if (candidate_flagellant.len() == 0)
		{
			return;
		}

		local candidate_other = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() != "background.flagellant" && bro.getBackground().getID() != "background.monk_turned_flagellant" && (bro.getBackground().isOffendedByViolence() || bro.getSkills().hasSkill("trait.fainthearted")))
			{
				candidate_other.push(bro);
			}
		}

		if (candidate_other.len() == 0)
		{
			return;
		}

		this.m.Flagellant = candidate_flagellant[this.Math.rand(0, candidate_flagellant.len() - 1)];
		this.m.OtherGuy = candidate_other[this.Math.rand(0, candidate_other.len() - 1)];
		this.m.Score = 5;
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
		_vars.push([
			"weakbro",
			this.m.OtherGuy.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Flagellant = null;
		this.m.OtherGuy = null;
	}

});

