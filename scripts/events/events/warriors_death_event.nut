this.warriors_death_event <- this.inherit("scripts/events/event", {
	m = {
		Gravedigger = null,
		Casualty = null
	},
	function create()
	{
		this.m.ID = "event.warriors_death";
		this.m.Title = "After the battle...";
		this.m.Cooldown = 200.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_87.png[/img]La bataille terminée, vous regardez autour de vous la destruction qu\'elle a causée. Le frère mort est sur le dos, fixant le ciel avec des yeux vitreux. D\'autres frères jonchent le champ de bataille. Ils sont mal formés, en lambeaux, fracturés et fragmentés et bientôt fermentés. C\'est une fin collectivement cruelle. Et maintenant les mouches se rassemblent, parsemant les morts comme des taupes rampantes. Elles copulent sur la peau froide avec un abandon éhonté et entreprennent de creuser la prochaine couvée dans le sang encore chaud. %randombrother% s\'approche et demande ce que vous voulez faire avec les corps.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Laissez-les là.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Rendons hommage à nos morts !",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Gravedigger != null)
				{
					this.Options.push({
						Text = "Laissons %gravedigger% le fossoyeur s\'en occuper.",
						function getResult( _event )
						{
							return "E";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_87.png[/img]Vous jetez un coup d\'oeil aux cieux. Des corbeaux et des arch-corbeaux tournent au-dessus de nos têtes. Ils crient et se chamaillent les uns les autres en attendant votre départ. En rengainant votre épée, vous hochez la tête vers le champ de bataille.%SPEECH_ON%Les corps sont pillés. Laissez les morts aux oiseaux.%SPEECH_OFF%.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Le monde a faim, après tout.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local r;
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					local chance = 25;

					if (bro.getBackground().getID() == "background.monk")
					{
						chance = 100;
					}
					else if (bro.getSkills().hasSkill("trait.fainthearted") || bro.getSkills().hasSkill("trait.craven") || bro.getSkills().hasSkill("trait.dastard") || bro.getSkills().hasSkill("trait.pessimist") || bro.getSkills().hasSkill("trait.superstitious") || bro.getSkills().hasSkill("trait.insecure") || bro.getSkills().hasSkill("trait.disloyal"))
					{
						chance = 75;
					}
					else if (bro.getSkills().hasSkill("trait.cocky") || bro.getSkills().hasSkill("trait.loyal") || bro.getSkills().hasSkill("trait.optimist") || bro.getSkills().hasSkill("trait.deathwish"))
					{
						chance = 10;
					}

					if (this.Math.rand(1, 100) > r)
					{
						continue;
					}

					bro.worsenMood(0.5, "Consterné que des camarades tombés au combat aient été laissés à l\'abandon sur le champ de bataille.");

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
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_28.png[/img]Vous faites un signe de tête en direction des morts.%SPEECH_ON% C\'était des hommes bien et les hommes bien ont droit à un bel enterrement. Nous les honorerons comme nous le devons : un bon trou pour dormir, des couronnes qu\'ils pourront dépenser dans l\'autre monde, et un festin pour célébrer. Je m\'attendrais à ce qu\'on fasse la même chose pour moi!%SPEECH_OFF%Les hommes survivants applaudissent et commencent les préparatifs.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Maintenant nous pouvons les laisser trouver leur dernier repos.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local r;
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					local chance = 50;

					if (this.Math.rand(1, 100) > r)
					{
						continue;
					}

					bro.improveMood(0.5, "Heureux de voir que les camarades tombés au combat reçoivent un bel adieu.");

					if (bro.getMoodState() >= this.Const.MoodState.Neutral)
					{
						this.List.push({
							id = 10,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}
				}

				this.World.Assets.addMoney(-60);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You spend [color=" + this.Const.UI.Color.NegativeEventValue + "]60[/color] Couronnes"
				});
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_28.png[/img]Vous confiez la tâche des enterrements à %gravedigger%, un homme bien entraîné à ce métier particulier. Il ne lui faut pas longtemps pour creuser des trous parfaitement carrés dans le sol. Il enveloppe les corps dans des linges avant de les placer soigneusement dans leur dernier repos. Au bout du compte, les tombes sont posées sur le sol comme s\'il s\'agissait d\'une clôture terrestre égarée. Chaque monticule de terre est précédé d\'un pieu sur lequel est gravé le nom du défunt.%gravedigger% tient sa pelle et tend ses mains sur le manche. Il hoche la tête en regardant son travail.%SPEECH_ON%Ils sont dans le pétrin.%SPEECH_OFF%L\'homme crache.%SPEECH_ON%La seule chose après eux maintenant ce sont les vers. J\'espère que ça ne vous dérange pas - mais partout où un homme va une fois qu\'il est mort, il y a une bouche qui a besoin d\'être nourrie. De peur que vous ne brûliez les corps, je suppose, mais on dit que même dans ce cas, les esprits ont leur compte.%SPEECH_OFF%Ramassant sa pelle, le fossoyeur se retourne et part comme si son travail et ses paroles n\'étaient que des rêves sur des rêves.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Eh bien... qu\'ils reposent en paix.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Gravedigger.getImagePath());
				local r;
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					local chance = 75;

					if (this.Math.rand(1, 100) > r)
					{
						continue;
					}

					bro.improveMood(0.5, "Heureux de voir que les camarades tombés au combat reçoivent un bel adieu.");

					if (bro.getMoodState() >= this.Const.MoodState.Neutral)
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
		if (this.Time.getVirtualTimeF() - this.World.Events.getLastBattleTime() > 8.0)
		{
			return;
		}

		local fallen = [];
		local fallen = this.World.Statistics.getFallen();

		if (fallen.len() < 3)
		{
			return;
		}

		local f0;
		local f1;

		foreach( f in fallen )
		{
			if (f.Expendable)
			{
				continue;
			}

			if (f0 == null)
			{
				f0 = f;
			}
			else if (f1 == null)
			{
				f1 = f;
			}
			else
			{
				break;
			}
		}

		if (f0 == null || f1 == null)
		{
			return;
		}

		if (f0.Time < this.World.getTime().Days || f1.Time < this.World.getTime().Days)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates_gravedigger = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.gravedigger")
			{
				candidates_gravedigger.push(bro);
			}
		}

		this.m.Casualty = f0.Name;

		if (candidates_gravedigger.len() != 0)
		{
			this.m.Gravedigger = candidates_gravedigger[this.Math.rand(0, candidates_gravedigger.len() - 1)];
		}

		this.m.Score = 500;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"gravedigger",
			this.m.Gravedigger != null ? this.m.Gravedigger.getNameOnly() : ""
		]);
		_vars.push([
			"deadbrother",
			this.m.Casualty
		]);
	}

	function onClear()
	{
		this.m.Gravedigger = null;
		this.m.Casualty = null;
	}

});

