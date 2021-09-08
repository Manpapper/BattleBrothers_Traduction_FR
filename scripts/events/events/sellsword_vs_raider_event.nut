this.sellsword_vs_raider_event <- this.inherit("scripts/events/event", {
	m = {
		Sellsword = null,
		Raider = null
	},
	function create()
	{
		this.m.ID = "event.sellsword_vs_raider";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 45.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_82.png[/img]Le pillard, %raider%, aiguise son arme près du feu de camp. Il raconte des histoires de ses journées passées à piller les côtes et à s\'enfuir avec des tas de butin, son sourire tordu se reflétant dans l\'éclat aiguisé de la lame. Le mercenaire écoute un moment puis se lève en riant...%SPEECH_ON%Oh, mon gars, tu racontes de sacrées histoires. Voici la mienne : J\'ai gagné mon pain en tuant des hommes, que ce soit chez eux ou au combat, mais des hommes quand même. Vous vous baladez dans vos bateaux, attendant que les hommes soient partis, puis vous vous précipitez sur les plages pour frapper les petits garçons, violer les jeunes filles et voler les vieux moines. T\'as pas de quoi te vanter, pilleur.%SPEECH_OFF%%raider% abaisse sa lame.%SPEECH_ON% Nous autres insulaires avons au moins de l\'honneur parmi nous, alors que toi tu poignarderais %companyname% dans le dos pour une couronne de plus dans ta bourse. Parle encore une fois de mon passé, mercenaire, et je ferai ronger les racines par le pied.%SPEECH_OFF% Un échange de mots entre combattants mène à quelque chose : un combat. Les lames clignotent et le sang coule. Le reste de la compagnie intervient avant que les dégâts ne soient trop importants.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "J\'en ai rien à faire d\'où vous venez, arrêtez de vous battre.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Sellsword.getImagePath());
				this.Characters.push(_event.m.Raider.getImagePath());

				if (this.Math.rand(1, 100) <= 50)
				{
					local injury1 = _event.m.Sellsword.addInjury(this.Const.Injury.Brawl);
					this.List.push({
						id = 10,
						icon = injury1.getIcon(),
						text = _event.m.Sellsword.getName() + " souffre de " + injury1.getNameOnly()
					});
				}
				else
				{
					_event.m.Sellsword.addLightInjury();
					this.List.push({
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Sellsword.getName() + " souffre de blessures légères"
					});
				}

				_event.m.Sellsword.worsenMood(0.5, "Got in a fight with " + _event.m.Raider.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Sellsword.getMoodState()],
					text = _event.m.Sellsword.getName() + this.Const.MoodStateEvent[_event.m.Sellsword.getMoodState()]
				});

				if (this.Math.rand(1, 100) <= 50)
				{
					local injury2 = _event.m.Raider.addInjury(this.Const.Injury.Brawl);
					this.List.push({
						id = 10,
						icon = injury2.getIcon(),
						text = _event.m.Raider.getName() + " souffre de " + injury2.getNameOnly()
					});
				}
				else
				{
					_event.m.Raider.addLightInjury();
					this.List.push({
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Raider.getName() + " souffre de blessures légères"
					});
				}

				_event.m.Raider.worsenMood(0.5, "Got in a fight with " + _event.m.Sellsword.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Raider.getMoodState()],
					text = _event.m.Raider.getName() + this.Const.MoodStateEvent[_event.m.Raider.getMoodState()]
				});
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

		local sellsword_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() <= 6 && bro.getBackground().getID() == "background.sellsword")
			{
				sellsword_candidates.push(bro);
				break;
			}
		}

		if (sellsword_candidates.len() == 0)
		{
			return;
		}

		local raider_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() <= 6 && bro.getBackground().getID() == "background.raider")
			{
				raider_candidates.push(bro);
			}
		}

		if (raider_candidates.len() == 0)
		{
			return;
		}

		this.m.Sellsword = sellsword_candidates[this.Math.rand(0, sellsword_candidates.len() - 1)];
		this.m.Raider = raider_candidates[this.Math.rand(0, raider_candidates.len() - 1)];
		this.m.Score = (sellsword_candidates.len() + raider_candidates.len()) * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"sellsword",
			this.m.Sellsword.getName()
		]);
		_vars.push([
			"raider",
			this.m.Raider.getName()
		]);
	}

	function onClear()
	{
		this.m.Sellsword = null;
		this.m.Raider = null;
	}

});

