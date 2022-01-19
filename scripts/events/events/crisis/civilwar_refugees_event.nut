this.civilwar_refugees_event <- this.inherit("scripts/events/event", {
	m = {
		AggroDude = null,
		InjuredDude = null,
		RefugeeDude = null
	},
	function create()
	{
		this.m.ID = "event.crisis.civilwar_refugees";
		this.m.Title = "Sur le chemin...";
		this.m.Cooldown = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_59.png[/img]{Une vraie guerre a beaucoup de vie malgré les victimes et celle-ci n\'est pas différente : en suivant un chemin, vous trouvez un grand groupe de réfugiés blottis les uns contre les autres. Ils se lavaient dans un ruisseau quand vous les avez découverts, un groupe à moitié nu et à moitié lavé et tout terrifié. Surtout des femmes et des enfants, quelques vieillards et quelques hommes qui semblent prêts à donner leur vie pour le reste, peu importe à quel point leur défense serait infructueuse. Un de ces hommes s\'avance.%SPEECH_ON%Que voulez-vous ?%SPEECH_OFF%%aggro_bro% s\'approche de vous.%SPEECH_ON%Monsieur, nous pourrions prendre tout ce qu\'ils ont, mais je suis sûr qu\'ils ne les donneront pas volontairement.%SPEECH_OFF%%injured_bro% secoue la tête.%SPEECH_ON%Je dirais que ça n\'en vaut pas la peine. Ces gens ont assez vécu comme ça et ils n\'ont plus grand-chose à donner au monde.%SPEECH_OFF% | Vous tombez sur une bande de réfugiés. Des femmes, des enfants, des personnes âgées et une poignée d\'hommes aux yeux écarquillés. Ils ont peu de valeur, mais ils ont quand même des choses qui valent la peine d\'être prises si vous faites l\'effort. | Réfugiés. Une bande d\'entre eux s'\enchaînait le long du chemin en une longue rangée. À votre vue, la tête du mille-pattes souffrant s\'arrête et tous les corps se mélangent lentement en une tache effrayante. %aggro_bro% suggère de les tuer et de prendre ce qu\'ils ont, bien que ce qu\'ils ont ne semble pas être grand-chose d\'après vos estimations.}",
			Image = "",
			Characters = [],
			Options = [
				{
					Text = "Laissez ces pauvres gens tranquilles.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local food = this.World.Assets.getFoodItems();

				if (food.len() > 2)
				{
					this.Options.push({
						Text = "Partagez quelques-unes de nos provisions avec ces pauvres gens.",
						function getResult( _event )
						{
							return "D";
						}

					});
				}

				if (_event.m.RefugeeDude != null && food.len() > 1)
				{
					this.Options.push({
						Text = "%refugee_bro%, vous étiez un réfugié. Parlez-leur?",
						function getResult( _event )
						{
							return "E";
						}

					});
				}

				this.Options.push({
					Text = "Cherchez des objets de valeur !",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(-3);

						if (this.Math.rand(1, 100) <= 50)
						{
							return "B";
						}
						else
						{
							return "C";
						}
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_59.png[/img]Vous ordonnez à vos hommes de prendre ce qu\'ils peuvent. Les réfugiés reculent d\'horreur et quelques protestations fusent alors que vos frères entrent dans leurs rangs. Soudain, l\'un des réfugiés prend une grosse pierre et frappe %injured_bro% sur la tête avec. Des femmes et des enfants crient et quelques autres hommes s\'agrippent aux mercenaires, se disputant des armes encore rengainées. Mais les âmes errantes n\'ont pas mangé depuis des jours et leurs corps affaiblis ne font pas le poids face à vos hommes. %companyname% prennent ce qu\'ils veullent.",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Connaissez votre place, imbéciles.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.InjuredDude.getImagePath());
				local injury = _event.m.InjuredDude.addInjury(this.Const.Injury.Accident3);
				this.List = [
					{
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.InjuredDude.getName() + " souffre " + injury.getNameOnly()
					}
				];
				_event.addLoot(this.List);
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_59.png[/img]Vous ordonnez à vos hommes de prendre ce qu\'ils peuvent. Les réfugiés reculent d\'horreur. Les femmes crient, les enfants, plus confus que compréhensifs, font de même. Certains hommes en larmes vous demandent simplement de partir. Malheureusement pour cette bande de vagabonds inutiles, la %companyname% prend ce qu\'elle veut. Vos hommes passent librement au crible la foule et finissent par revenir avec leurs prises.",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Ils ne savent pas résister.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.addLoot(this.List);
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_59.png[/img]{Vous dites à %randombrother% de donner de la nourriture aux réfugiés. Le groupe déconcerté vous regarde avec incrédulité tandis qu\'on leur tend du pain et une bonbonne d\'eau. Un vieil homme s\'approche et se met à genoux en tremblant pour vous embrasser les pieds. Vous relevez l\'homme et lui dites qu\'il n'y a pas besoin d\'un tel spectacle. Quelques-uns des mercenaires ricanent et vous appellent \'La pâte des pâtes, le roi du pain rassis.\' | Ces personnes se feraient facilement voler, mais vous avez l\'impression que de telles actes ne seraient pas bien accueillies lorsque la nouvelle se répandrait dans la région. Au lieu de cela, vous ordonnez à %randombrother% de commencer à distribuer de la nourriture et de l\'eau. Les réfugiés sont d\'une joie agaçante, vous regardant comme si vous étiez un dieu. Vous avez juste de la vieille nourriture à vous débarrasser. Là encore, certains disent que lorsque les anciens dieux étaient plus humains, les hommes étaient plus divins.}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Voyager en toute sécurité.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(3);
				local food = this.World.Assets.getFoodItems();

				for( local i = 0; i < 2; i = ++i )
				{
					local idx = this.Math.rand(0, food.len() - 1);
					local item = food[idx];
					this.List.push({
						id = 10,
						icon = "ui/items/" + item.getIcon(),
						text = "Vous donnez " + item.getName()
					});
					this.World.Assets.getStash().remove(item);
					food.remove(idx);
				}

				this.World.Assets.updateFood();
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_59.png[/img]Vous décidez de compter sur un homme qui a une expérience personnelle en tant que réfugié : %refugee_bro%.\n\nLe mercenaire se dirige vers la masse sanglotante et priante des voyageurs fatigués. Il discute un moment avec eux et partage de la nourriture, ses gesticulations amicales et les récits de son propre passé amenant peu à peu la foule à ses côtés. Vous regardez un vieil homme lui tendre quelque chose enveloppé dans de la peau de mouton avec des lanières de cuir en dessous. Le mercenaire s\'incline, serre la main de l\'homme et revient.\n\nIl jette la peau de mouton pour dévoiler une épée qui brille dans la lumière aussi fortement que vous pouvez imaginer qu\'elle coupe. %refugee_bro% sourit.%SPEECH_ON%Comme ma mère l\'a toujours dit, un peu d\'amitié ne fait jamais de mal à personne, mais cette épée le fera certainement !%SPEECH_OFF%",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Beau travail avec les subtilités.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(3);
				this.Characters.push(_event.m.RefugeeDude.getImagePath());
				local food = this.World.Assets.getFoodItems();
				local item = food[this.Math.rand(0, food.len() - 1)];
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous donnez " + item.getName()
				});
				this.World.Assets.getStash().remove(item);
				this.World.Assets.updateFood();
				local r = this.Math.rand(1, 2);
				local sword;

				if (r == 1)
				{
					sword = this.new("scripts/items/weapons/arming_sword");
				}
				else if (r == 2)
				{
					sword = this.new("scripts/items/weapons/falchion");
				}

				this.List.push({
					id = 10,
					icon = "ui/items/" + sword.getIcon(),
					text = "Vous gagnez " + this.Const.Strings.getArticle(sword.getName()) + sword.getName()
				});
				this.World.Assets.getStash().add(sword);
			}

		});
	}

	function addLoot( _list )
	{
		local r = this.Math.rand(1, 3);
		local food;

		if (r == 1)
		{
			food = this.new("scripts/items/supplies/dried_fish_item");
		}
		else if (r == 2)
		{
			food = this.new("scripts/items/supplies/ground_grains_item");
		}
		else
		{
			food = this.new("scripts/items/supplies/bread_item");
		}

		_list.push({
			id = 10,
			icon = "ui/items/" + food.getIcon(),
			text = "Vous gagnez " + food.getName()
		});
		this.World.Assets.getStash().add(food);
		this.World.Assets.updateFood();

		for( local i = 0; i < 2; i = ++i )
		{
			r = this.Math.rand(1, 10);
			local item;

			if (r == 1)
			{
				item = this.new("scripts/items/weapons/wooden_stick");
			}
			else if (r == 2)
			{
				item = this.new("scripts/items/armor/tattered_sackcloth");
			}
			else if (r == 3)
			{
				item = this.new("scripts/items/weapons/knife");
			}
			else if (r == 4)
			{
				item = this.new("scripts/items/helmets/hood");
			}
			else if (r == 5)
			{
				item = this.new("scripts/items/weapons/woodcutters_axe");
			}
			else if (r == 6)
			{
				item = this.new("scripts/items/shields/wooden_shield_old");
			}
			else if (r == 7)
			{
				item = this.new("scripts/items/weapons/pickaxe");
			}
			else if (r == 8)
			{
				item = this.new("scripts/items/armor/leather_wraps");
			}
			else if (r == 9)
			{
				item = this.new("scripts/items/armor/linen_tunic");
			}
			else if (r == 10)
			{
				item = this.new("scripts/items/helmets/feathered_hat");
			}

			this.World.Assets.getStash().add(item);
			_list.push({
				id = 10,
				icon = "ui/items/" + item.getIcon(),
				text = "Vous gagnez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
			});
		}
	}

	function onUpdateScore()
	{
		if (!this.World.FactionManager.isCivilWar())
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.Const.DLC.Desert && currentTile.SquareCoords.Y <= this.World.getMapSize().Y * 0.2)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates_aggro = [];
		local candidates_other = [];
		local candidates_refugees = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().isCombatBackground() || bro.getSkills().hasSkill("trait.bloodthirsty") || bro.getSkills().hasSkill("trait.brute"))
			{
				candidates_aggro.push(bro);
			}
			else if (bro.getBackground().getID() == "background.refugee")
			{
				candidates_refugees.push(bro);
			}
			else if (!bro.getSkills().hasSkill("trait.player") && bro.getBackground().getID() != "background.slave")
			{
				candidates_other.push(bro);
			}
		}

		if (candidates_aggro.len() == 0 || candidates_other.len() == 0)
		{
			return;
		}

		this.m.AggroDude = candidates_aggro[this.Math.rand(0, candidates_aggro.len() - 1)];
		this.m.InjuredDude = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];

		if (candidates_refugees.len() != 0)
		{
			this.m.RefugeeDude = candidates_refugees[this.Math.rand(0, candidates_refugees.len() - 1)];
		}

		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"aggro_bro",
			this.m.AggroDude.getName()
		]);
		_vars.push([
			"injured_bro",
			this.m.InjuredDude.getName()
		]);
		_vars.push([
			"refugee_bro",
			this.m.RefugeeDude != null ? this.m.RefugeeDude.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.AggroDude = null;
		this.m.InjuredDude = null;
		this.m.RefugeeDude = null;
	}

});

