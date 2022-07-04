this.wild_dog_sounds_event <- this.inherit("scripts/events/event", {
	m = {
		Hunter = null,
		Wildman = null,
		Expendable = null
	},
	function create()
	{
		this.m.ID = "event.wild_dog_sounds";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 90.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_33.png[/img]{Alors que la compagnie campe, %randombrother% arrête d\'aiguiser une lame et lève les yeux.%SPEECH_ON%Vous avez entendu ça?%SPEECH_OFF%Vous avez entendu oui. Les chiens sauvages aboient et hurlent. Vous haussez les épaules et dites que ce n\'est rien, mais à ce moment-là, il y a un jappement et les jappements se transforment en grognements puis vous entendez le son distinct d\'une lutte animale. Les grognements se transforment en gémissements. Quelque chose est en train de perdre le combat. %randombrother% se tourne vers vous.%SPEECH_ON%Ça a l\'air proche, on devrait aller voir ? Je ne veux pas dormir avec ça dans les parages.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ignorez-le.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Hunter != null)
				{
					this.Options.push({
						Text = "Vous êtes un chasseur, %hunter%, allez voir.",
						function getResult( _event )
						{
							return "D";
						}

					});
				}

				if (_event.m.Wildman != null)
				{
					this.Options.push({
						Text = "Vous êtes un homme de la nature, %wildman%, allez voir.",
						function getResult( _event )
						{
							return "E";
						}

					});
				}

				if (_event.m.Expendable != null)
				{
					this.Options.push({
						Text = "On dirait un travail pour le nouveau. Va jeter un coup d\'oeil, %recruit%!",
						function getResult( _event )
						{
							return this.Math.rand(1, 100) <= 40 ? "F" : "G";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_33.png[/img]{Vous dites à la compagnie d\'ignorer les sons. C\'est une tâche difficile à accomplir car les cris des chiens sauvages sont de plus en plus forts jusqu\'à ce qu\'ils s\'arrêtent. Vos hommes ne bougent pas, comme si le moindre bruit pouvait déclencher l\'enfer de n\'importe quelle horreur qu\'il y a dehors. Rien ne se passe, mais un certain nombre d\'hommes ont du mal à dormir la nuit.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Faites-vous pousser une paire, bande d\'idiots.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.hunter" || bro.getBackground().getID() == "background.poacher" || bro.getBackground().getID() == "background.beast_hunter")
					{
						continue;
					}

					if (bro.getBackground().getID() == "background.wildman" || bro.getBackground().getID() == "background.barbarian")
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 25)
					{
						bro.worsenMood(0.5, "Didn\'t get a good night\'s sleep");
						local effect = this.new("scripts/skills/effects_world/exhausted_effect");
						bro.getSkills().add(effect);
						this.List.push({
							id = 10,
							icon = effect.getIcon(),
							text = bro.getName() + " is exhausted"
						});
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_33.png[/img]{Vous dites à la compagnie de se boucher les oreilles si c\'est si génant. Alors que les cris des chiens sauvages se font de plus en plus forts, les hommes ont recours à des bouchons d\'oreilles improvisées pour faire taire les sons. Finalement, les mercenaires privés de sens se promènent maladroitement comme des robots. Vous cherchez à imiter les muets, en vous mettant une boule de cire dans l\'oreille, mais avant que vous fassiez la même chose pour la deuxième oreille, un grand fracas renverse les stocks et une tente s\'effondre. Vous enlevez vos bouchons et aboyez des ordres aux mercenaires qui sont éparpillés dans le camp.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Aux armes, bande de sourds!",
					function getResult( _event )
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.BeastsTracks;
						properties.Entities = [];
						properties.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.Unhold, this.Math.rand(80, 100), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID());
						this.World.State.startScriptedCombat(properties, false, false, true);
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_14.png[/img]{Il semble que les hommes ne seront pas calmés en leur disant de se faire pousser une paire. %hunter% choisit d\'aller voir ce qui se passe, car il est sûr qu\'il ne s\'agit que de chiens sauvages qui se disputent la suprématie de la meute. Vous l\'envoyez voir, l\'homme s\'aventurant dans l\'obscurité tout seul. Dès qu\'il est parti, les canidés cessent de pleurer, on entend un grognement qui semble venir d\'un endroit beaucoup plus éloigné. Le camp entier est silencieux, personne n\'ose bouger.\n\n Une heure plus tard, le chasseur rentre au camp, personne ne l\'ayant entendu arriver. Il s\'est camouflé dans de la boue mélangée à des brindilles et des feuilles. Il a greffé des tiges dans une capuche qu\'il porte comme une abbesse arboricole. A voix basse, les mercenaires lui demandent ce qu\'il a vu. Il hausse les épaules.%SPEECH_ON%Eh bien. J\'ai vu une douzaine de chiens morts. J\'ai ai trouvé quelques-uns dans une fosse qui ressemblait à une grande emprunte de pas. Ils ont été piétinés là. Et j\'ai vu quelque chose bouger dans l\'ombre entre les cimes des arbres, il est parti dans l\'autre sens mais je ne l\'ai pas suivi. J\'ai trouvé un cerf mort, réplié sur ses pattes, appuyé contre un arbre. Son cœur a été ébranlé par ce qu\'il a vu, je suppose. J\'ai récolté tout ce que je pouvais.%SPEECH_OFF%L\'homme se retourne et fait avancer un râtelier de viande accroché à un panneau de bois et de feuilles.%SPEECH_ON%Quelqu\'un a faim ?%SPEECH_OFF%} ",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Un sacré voyage, je suppose.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Hunter.getImagePath());
				local item = this.new("scripts/items/supplies/cured_venison_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
				_event.m.Hunter.getBaseProperties().Bravery += 1;
				_event.m.Hunter.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Hunter.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Resolve"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.hunter" || bro.getBackground().getID() == "background.poacher" || bro.getBackground().getID() == "background.beast_hunter")
					{
						continue;
					}

					if (bro.getBackground().getID() == "background.wildman" || bro.getBackground().getID() == "background.barbarian")
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 15)
					{
						bro.worsenMood(0.5, "Concerned that there\'s something big out there");
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_33.png[/img]{La peur s\'empare du camp, mais vous attirez %wildman% à vos côtés. Le sauvage souffle bruyamment et passe sa main le long de son nez comme si vous aviez dérangé la notion inexplicable qu\'il a de son propre temps. Il lève un sourcil alors que vous lui suggérez, au mieux de vos capacités de pantomime, d\'aller chercher d\'où vient le bruit. Sans autre indication, l\'homme grogne et s\'enfonce dans les bois.\n\n Vous jurez qu\'il est à une bonne centaine de mètres mais vous pouvez toujours l\'entendre foncer dans les buissons en faisant tout le bruit du monde. Les chiens sauvages cessent de hurler et à leur place, on entend un grognement fort et les glapissements d\'un plus petit chien. Ils se balancent d\'avant en arrière, vous pouvez sentir le sol trembler sous vos pieds. Les vibrations faiblissent et s\'estompent, les cris s\'arrêtent complètement. Au moment où vous commencez à vous inquiéter, votre compagnon revient au camp. Il s\'assied près du feu de camp, bâille, se retourne et s\'endort. Comme s\'il n\'était jamais parti.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Le problème est réglé, je pense.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Wildman.getImagePath());
				_event.m.Wildman.improveMood(1.0, "Had a good night\'s sleep");

				if (_event.m.Wildman.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Wildman.getMoodState()],
						text = _event.m.Wildman.getName() + this.Const.MoodStateEvent[_event.m.Wildman.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_33.png[/img]{Vous regardez la compagnie. Un jeune %recrue% se retourne. Il baisse les yeux, comme pour regarder en lui-même, puis se lève précipitamment.%SPEECH_ON%N\'en dites pas plus, capitaine. Je vais découvrir d'où vient cette agitation.%SPEECH_OFF%La nouvelle recrue rassemble ses affaires et se tient à la lisière du camp, une forêt très sombre lui faisant face. L\'homme fixe à nouveau le sol puis serre et desserre les mains.%SPEECH_ON%C\'est bon. C\'est bon.%SPEECH_OFF%Il lève les yeux.%SPEECH_ON%Allons-y.%SPEECH_OFF%L\'homme n\'a jamais été revu.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Peut-être qu\'envoyer un blanc-bec n\'était pas la meilleure idée.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Expendable.getImagePath());
				local dead = _event.m.Expendable;
				local fallen = {
					Name = dead.getName(),
					Time = this.World.getTime().Days,
					TimeWithCompany = this.Math.max(1, dead.getDaysWithCompany()),
					Kills = dead.getLifetimeStats().Kills,
					Battles = dead.getLifetimeStats().Battles,
					KilledBy = "Went missing",
					Expendable = dead.getBackground().getID() == "background.slave"
				};
				this.World.Statistics.addFallen(fallen);
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.Expendable.getName() + " went missing"
				});
				_event.m.Expendable.getItems().transferToStash(this.World.Assets.getStash());
				_event.m.Expendable.getSkills().onDeath(this.Const.FatalityType.None);
				this.World.getPlayerRoster().remove(_event.m.Expendable);
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_33.png[/img]{Vous regardez la compagnie.Un jeune %recrue% regarde en arrière. Il baisse les yeux, comme pour regarder en lui-même, puis se lève précipitamment.%SPEECH_ON%N\\'en dites pas plus, capitaine. Je vais découvrir d\'où vient cette agitation.%SPEECH_OFF%La nouvelle recrue rassemble ses affaires et se tient à la lisière du camp, une forêt très sombre lui faisant face. L\\'homme fixe à nouveau le sol puis serre et desserre les mains. Il souffle et s\'avance, se glissant immédiatement dans l\'ombre. Les heures passent. Finalement, il revient. Ses vêtements sont en lambeaux. Ses armes ont disparu. Il déblatère des histoires absurdes. Anneaux magiques, volcans, aigles géants, tout ça n\'a aucun sens. Peu importe ce qu\'il a vu, il est clair que le mercenaire a besoin de se vider la tête grâce à un sommeil réparateur bien mérité. Ce qu\'il obtiendra puisque tout ce vacarme affreux a cessé.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Va dormir, petit.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Expendable.getImagePath());
				_event.m.Expendable.addXP(200, false);
				_event.m.Expendable.updateLevel();
				this.List.push({
					id = 16,
					icon = "ui/icons/xp_received.png",
					text = _event.m.Expendable.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+200[/color] Experience"
				});
				_event.m.Expendable.improveMood(3.0, "Had an excellent adventure");

				if (_event.m.Expendable.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Expendable.getMoodState()],
						text = _event.m.Expendable.getName() + this.Const.MoodStateEvent[_event.m.Expendable.getMoodState()]
					});
				}

				local items = _event.m.Expendable.getItems();

				if (items.getItemAtSlot(this.Const.ItemSlot.Mainhand) != null && items.getItemAtSlot(this.Const.ItemSlot.Mainhand).isItemType(this.Const.Items.ItemType.Weapon) && !items.getItemAtSlot(this.Const.ItemSlot.Mainhand).isItemType(this.Const.Items.ItemType.Legendary) && !items.getItemAtSlot(this.Const.ItemSlot.Mainhand).isItemType(this.Const.Items.ItemType.Named))
				{
					this.List.push({
						id = 10,
						icon = "ui/items/" + items.getItemAtSlot(this.Const.ItemSlot.Mainhand).getIcon(),
						text = "Vous perdez " + this.Const.Strings.getArticle(items.getItemAtSlot(this.Const.ItemSlot.Mainhand).getName()) + items.getItemAtSlot(this.Const.ItemSlot.Mainhand).getName()
					});
					items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
				}

				if (items.getItemAtSlot(this.Const.ItemSlot.Head) != null)
				{
					items.getItemAtSlot(this.Const.ItemSlot.Head).setCondition(this.Math.max(1, items.getItemAtSlot(this.Const.ItemSlot.Head).getConditionMax() * this.Math.rand(10, 40) * 0.01));
				}

				if (items.getItemAtSlot(this.Const.ItemSlot.Body) != null)
				{
					items.getItemAtSlot(this.Const.ItemSlot.Body).setCondition(this.Math.max(1, items.getItemAtSlot(this.Const.ItemSlot.Body).getConditionMax() * this.Math.rand(10, 40) * 0.01));
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen || !this.Const.DLC.Unhold)
		{
			return;
		}

		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.getTime().Days < 20)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.LeaveForest && currentTile.Type != this.Const.World.TerrainType.SnowyForest)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_hunter = [];
		local candidates_wildman = [];
		local candidates_recruit = [];
		local others = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.hunter" || bro.getBackground().getID() == "background.poacher" || bro.getBackground().getID() == "background.beast_hunter")
			{
				candidates_hunter.push(bro);
			}
			else if (bro.getBackground().getID() == "background.wildman")
			{
				candidates_wildman.push(bro);
			}
			else if (bro.getXP() == 0)
			{
				candidates_recruit.push(bro);
			}
			else
			{
				others.push(bro);
			}
		}

		if (candidates_hunter.len() == 0 && candidates_wildman.len() == 0 && candidates_recruit.len() == 0 || others.len() == 0)
		{
			return;
		}

		if (candidates_hunter.len() != 0)
		{
			this.m.Hunter = candidates_hunter[this.Math.rand(0, candidates_hunter.len() - 1)];
		}

		if (candidates_wildman.len() != 0)
		{
			this.m.Wildman = candidates_wildman[this.Math.rand(0, candidates_wildman.len() - 1)];
		}

		if (candidates_recruit.len() != 0)
		{
			this.m.Expendable = candidates_recruit[this.Math.rand(0, candidates_recruit.len() - 1)];
		}

		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"hunter",
			this.m.Hunter.getName()
		]);
		_vars.push([
			"wildman",
			this.m.Wildman ? this.m.Wildman.getName() : ""
		]);
		_vars.push([
			"recruit",
			this.m.Expendable ? this.m.Expendable.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Hunter = null;
		this.m.Wildman = null;
		this.m.Expendable = null;
	}

});

