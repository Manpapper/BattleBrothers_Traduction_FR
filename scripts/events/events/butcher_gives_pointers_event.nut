this.butcher_gives_pointers_event <- this.inherit("scripts/events/event", {
	m = {
		Butcher = null,
		Flagellant = null
	},
	function create()
	{
		this.m.ID = "event.pointers_from_butcher";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_38.png[/img]Vous trouvez %butcher% le boucher qui trace une ligne avec son doigt le long du dos nu de %flagellant%. Il trouve un point entre les tendons et les cicatrices et tapote.%SPEECH_ON%Ici. Si vous vous frappez ici, la plus grande quantité de viande - je veux dire de muscle, serait touché.%SPEECH_OFF%Le flagellant lève les yeux.%SPEECH_ON%Est-ce que ce sera douloureux ?%SPEECH_OFF%Un sourire traverse le visage du boucher.%SPEECH_ON%Oh oui, tout à fait.%SPEECH_OFF%Il semble que l\'homme donne au flagellant des conseils sur la façon de faire le plus mal possible. Avant que vous ne puissiez intervenir, %flagellant% prend un fouet et se frappe lui-même à l\'endroit où %butcher% lui avait indiqué de le faire. Les vrilles de cuir, de verre et d\'os aiguisés se heurtent au dos de l\'homme, s\'enfoncent et, déchirent sa chair.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Pourquoi diable lui montrerais-tu ça ?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Butcher.getImagePath());
				this.Characters.push(_event.m.Flagellant.getImagePath());
				_event.m.Flagellant.getFlags().add("pointers_from_butcher");
				_event.m.Flagellant.getBaseProperties().MeleeSkill += 2;
				_event.m.Flagellant.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_skill.png",
					text = _event.m.Flagellant.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+2[/color] de Maîtrise de Mêlée"
				});
				local injury = _event.m.Flagellant.addInjury(this.Const.Injury.Flagellation);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Flagellant.getName() + " souffre de  " + injury.getNameOnly()
				});
				_event.m.Butcher.improveMood(2.0, "A pris du plaisir dans la douleur de quelqu\'un d\'autre.");

				if (_event.m.Butcher.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Butcher.getMoodState()],
						text = _event.m.Butcher.getName() + this.Const.MoodStateEvent[_event.m.Butcher.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_butcher = [];
		local candidates_flagellant = [];

		foreach( bro in brothers )
		{
			if (bro.getFlags().has("pointers_from_butcher"))
			{
				continue;
			}

			if (bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.butcher")
			{
				candidates_butcher.push(bro);
			}
			else if (bro.getBackground().getID() == "background.flagellant" || bro.getBackground().getID() == "background.monk_turned_flagellant")
			{
				candidates_flagellant.push(bro);
			}
		}

		if (candidates_butcher.len() == 0 || candidates_flagellant.len() == 0)
		{
			return;
		}

		this.m.Butcher = candidates_butcher[this.Math.rand(0, candidates_butcher.len() - 1)];
		this.m.Flagellant = candidates_flagellant[this.Math.rand(0, candidates_flagellant.len() - 1)];
		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"butcher",
			this.m.Butcher.getNameOnly()
		]);
		_vars.push([
			"flagellant",
			this.m.Flagellant.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Butcher = null;
		this.m.Flagellant = null;
	}

});

