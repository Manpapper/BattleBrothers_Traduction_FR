this.sellsword_vs_bees_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null,
		Wildman = null
	},
	function create()
	{
		this.m.ID = "event.sellsword_vs_bees";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 70.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{Le désert n\'abrite pas grand-chose en dehors du sable. Il est donc assez particulier de tomber sur un arbre isolé qui se dresse tout seul, et encore plus étrange que, accrochée à une branche, se trouve une grosse ruche avec une nuée d\'ouvrières grouillant autour de sa forme bulbeuse. Même à quelque distance, on peut voir scintiller la braise dorée de leur miel...}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				this.Options.push({
					Text = "Que quelqu\'un aille le chercher !",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "Good" : "Fail";
					}

				});

				if (_event.m.Wildman != null)
				{
					this.Options.push({
						Text = "Looks like %wildmanfull% veut y aller.",
						function getResult( _event )
						{
							return "Wildman";
						}

					});
				}

				this.Options.push({
					Text = "Allons-y. Rien de bon ne peut sortir de ça.",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "Good",
			Text = "%terrainImage%{%chosen% s\'avance avec assurance vers l\'arbre et les abeilles semblent repoussées par sa seule présence. Le bruit de leurs battements s\'épaissit avec des vibrations de colère, mais autrement elles ne s\'offensent pas plus. Il dépose avec précaution une partie du miel dans un pot, puis se retire et s\'éloigne. Il retourne vers la compagnie.%SPEECH_ON%C\'est facile, c\'est facile de presser une ruche, les gars.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Buzzez tant que vous voulez, ce miel est à nous !",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 50)
					{
						bro.improveMood(0.75, "Apprécié un peu de miel dans le désert");

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
			}

		});
		this.m.Screens.push({
			ID = "Fail",
			Text = "%terrainImage%{%chosen% Il lace ses doigts et fait craquer ses articulations en s\'étirant longuement.%SPEECH_ON%Comme si on volait des bonbons à un bébé.%SPEECH_OFF%Il marche jusqu\'à l\'arbre et se tient sous la ruche. Il prend la pose et la montre du doigt, rit, puis tourne ses mains vers le haut et - à la grande surprise de tous - attrape la ruche entière. Les abeilles envahissent instantanément le vendeur, qui laisse tomber la ruche et s\'enfuit en courant, un nuage de bourdonnements furieux le poursuivant sur une dune de sable. Il roule et roule, ses cris retentissant à chaque fois qu\'il s\'envole hors du sable, puis il atterrit en bas et une vague de sable le recouvre et l\'épargne de nouvelles piqûres d\'abeilles. Vous attendez un moment avant de le récupérer, de peur que les abeilles ne sachent que vous avez participé à cette tentative de vol.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ne refaisons pas ça.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
				_event.m.Dude.addHeavyInjury();
				_event.m.Dude.worsenMood(2.0, "a été brutalisé par des abeilles");
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.Dude.getName() + " subit de lourdes blessures"
				});

				if (_event.m.Dude.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Dude.getMoodState()],
						text = _event.m.Dude.getName() + this.Const.MoodStateEvent[_event.m.Dude.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Wildman",
			Text = "%terrainImage%{Tu es sûr que %wildman% le sauvage a vu une ruche ou deux depuis qu\'il s\'est retiré dans les forêts. Il grogne et désigne la ruche, puis lui-même. Vous acquiescez. Il grogne à nouveau et monte sur la dune de sable jusqu\'à l\'arbre pendant que vous observez à une distance sûre. Lorsqu\'il se trouve sous la ruche, il hulule à nouveau, mettant sa main sur sa bouche pour s\'assurer que vous l\'entendez. Il pointe la ruche du doigt. Vous hochez à nouveau la tête et pointez agressivement la ruche. C\'est la seule ruche à des kilomètres à la ronde, qu\'est-ce qui pourrait bien être si déroutant dans tout ça ? Le sauvageon se tourne vers la ruche. Il met un bras en arrière. Ce... ce n\'est pas ce que vous vouliez voir. Il jauge la ruche, la langue sortie, les yeux bridés. Vous vous précipitez en avant, en lui criant dessus, mais il est déjà dans la ligne de mire. Il lance son poing et anéantit les abeilles. Les rayons de miel s\'agitent autour de son poignet comme si son bras poilu était un mât de mai improvisé. Le Wildman retourne tranquillement en bas de la dune de sable. Alors qu\'il s\'approche, vous voyez les abeilles ramper sur son visage et le piquer comme les sauvages enragés qu\'elles sont, mais il ne semble même pas sentir leur présence. Il tend les restes croustillants de sa démolition mielleuse comme s\'il tenait le cœur d\'une bête féroce.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bon... travail",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Wildman.getImagePath());
				_event.m.Wildman.addLightInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.Wildman.getName() + " souffre de blessures légères"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 50 || bro.getID() == _event.m.Wildman.getID())
					{
						bro.improveMood(0.75, "Apprécié un peu de miel dans le désert");

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
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Desert && currentTile.TacticalType != this.Const.World.TerrainTacticalType.DesertHills)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(currentTile) <= 5)
			{
				return;
			}
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];
		local candidates_wildman = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.wildman")
			{
				candidates_wildman.push(bro);
			}
			else
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Dude = candidates[this.Math.rand(0, candidates.len() - 1)];

		if (candidates_wildman.len() != 0)
		{
			this.m.Wildman = candidates_wildman[this.Math.rand(0, candidates_wildman.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"wildman",
			this.m.Wildman != null ? this.m.Wildman.getNameOnly() : ""
		]);
		_vars.push([
			"wildmanfull",
			this.m.Wildman != null ? this.m.Wildman.getName() : ""
		]);
		_vars.push([
			"chosen",
			this.m.Dude.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Dude = null;
		this.m.Wildman = null;
	}

});

