this.mutated_gladiator_annoys_others_event <- this.inherit("scripts/events/event", {
	m = {
		Gladiator = null
	},
	function create()
	{
		this.m.ID = "event.mutated_gladiator_annoys_others";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 65.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]{Depuis que le gladiateur %gladiator% a ingurgité l\'une des spécialités de l\'anatomiste, le combattant n\'a cessé de se renforcer. Nombreux sont ceux qui s\'agacent de voir cet homme bronzé, luisant et musclé exiger que les autres mercenaires l\'affrontent, un contre un, nu, dans des combats de lutte. Quand il n\'est pas en train de faire des combats de catch, il fait des exercices, criant entre chaque série comme s\'il était dans une bataille rangée. Espérons que cette période de sa vie se termine bientôt.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Au moins, il se sent en pleine forme...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Gladiator.getImagePath());
				_event.m.Gladiator.getFlags().set("PumpedAboutMutations", true);
				_event.m.Gladiator.getBaseProperties().Hitpoints += 1;
				_event.m.Gladiator.getBaseProperties().Bravery += 1;
				_event.m.Gladiator.getBaseProperties().Stamina += 1;
				_event.m.Gladiator.getBaseProperties().Initiative += 1;
				_event.m.Gladiator.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/health.png",
					text = _event.m.Gladiator.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Hitpoints"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Gladiator.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Resolve"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/fatigue.png",
					text = _event.m.Gladiator.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Fatigue"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/initiative.png",
					text = _event.m.Gladiator.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Initiative"
				});
				_event.m.Gladiator.improveMood(0.5, "Feels better than ever");

				if (_event.m.Gladiator.getMoodState() > this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Gladiator.getMoodState()],
						text = _event.m.Gladiator.getName() + this.Const.MoodStateEvent[_event.m.Gladiator.getMoodState()]
					});
				}

				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Gladiator.getID())
					{
						continue;
					}

					bro.worsenMood(1.0, "Annoyed by " + _event.m.Gladiator.getName() + "\'s antics");

					if (bro.getMoodState() < this.Const.MoodState.Neutral)
					{
						this.List.push({
							id = 10,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.anatomists")
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local gladiator_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.gladiator" && !bro.getSkills().hasSkill("injury.sickness") && !bro.getFlags().has("PumpedAboutMutations") && bro.getFlags().getAsInt("ActiveMutations") > 0)
			{
				gladiator_candidates.push(bro);
			}
		}

		if (gladiator_candidates.len() == 0)
		{
			return;
		}

		this.m.Gladiator = gladiator_candidates[this.Math.rand(0, gladiator_candidates.len() - 1)];
		this.m.Score = 3 * gladiator_candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"gladiator",
			this.m.Gladiator.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Gladiator = null;
	}

});

