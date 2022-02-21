this.greenskins_caravan_ambush_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.crisis.greenskins_caravan_ambush";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_59.png[/img]{Au sommet d\'une petite colline, vous voyez une caravane de personnes le long de la route. Ils dévalent le chemin avec des casseroles et des poêles qui s\'entrechoquent le long des côtés du chariot, des enfants balançant leurs jambes sur les bords, des femmes à l\'avant faisant avancer les animaux de trait avec des coups de fouet aigus. Des hommes marchent ensemble, regardent une carte et se disputent dessus, gesticulant dans des directions différentes pour montrer une différence d\'opinion géographique. Et puis, plus loin sur la route, au-delà des yeux des voyageurs, se trouvent quelques gobelins couchés dans l\'herbe. %randombrother% les voit aussi et commente.%SPEECH_ON%Nous ferions mieux d\'y aller maintenant, monsieur, avant qu\'il n\'y ait un massacre.%SPEECH_OFF%%randombrother2% hausse les épaules.%SPEECH_ON%Ou... nous laissons les gobelins se déplacent, puis nous nous précipitons et nettoyons les dégâts. Plus facile de les combattre quand ils sont occupés, non ?%SPEECH_OFF%}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Nous attaquons maintenant !",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Nous attendons que les gobelins attaquent en premier, puis nous chargeons !",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Nous n\'avons pas besoin de nous impliquer là-dedans. Continuons!",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_48.png[/img]{Vous ne sacrifierez pas ces personnes innocentes pour un avantage tactique ! Vous ordonnez aux hommes d\'attaquer maintenant. Les gobelins vous entendent immédiatement venir et tourner la tête. Au loin, les paysans s\'éloignent, voyant le danger à venir. Il semble que vous les ayez sauvés, mais maintenant vous devrez affronter les gobelins au complet !}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Aux armes!",
					function getResult( _event )
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.GoblinsTracks;
						properties.Entities = [];
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.GoblinRaiders, this.Math.rand(90, 110) * _event.getReputationToDifficultyLightMult(), this.Const.Faction.Enemy);
						_event.registerToShowAfterCombat("AftermathB", null);
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
			ID = "AftermathB",
			Text = "[img]gfx/ui/events/event_83.png[/img]{Une fois les gobelins exterminés, les paysans ramènent lentement leurs chariots. Ils regardent la scène avec beaucoup d\'admiration. On vous serre la main.%SPEECH_ON%Par tous les anciens dieux, tous ceux que nous rencontrons entendront le nom %companyname% !%SPEECH_OFF%Quelques autres vous donnent de la nourriture, des bisous et beaucoup de remerciements.}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Ce n\'était rien, honnêtement.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnPartyDestroyed);
				this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
				this.List.push({
					id = 10,
					icon = "ui/icons/special.png",
					text = "La compagnie gagne en renommée"
				});
				this.World.Assets.addMoralReputation(3);
				local food = this.new("scripts/items/supplies/bread_item");
				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "Vous obtenez " + food.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_60.png[/img]{Vous ordonnez aux hommes d\'attendre le bon moment.\n\n Lorsque les paysans s\'avancent plus loin sur la route, les gobelins les ont attaqués avec une volée de flèches empoisonnées. Les hommes qui se disputent tombent, des flèches plantées dans la poitrine, les muscles se raidissant, les visages tendus alors que le poison se propage. Quelques autres hommes attrapent les rênes des mains de leurs femmes et dirigent les chariots. Certains montent une arrière garde, des fermiers à fourches, ils ne tiennent pas longtemps face aux gobbos déshonorants. Voyant que les gobelins sont dispersés dans leur attaque, vous ordonnez à %companyname% de commencer sa propre embuscade.}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Aux armes!",
					function getResult( _event )
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.GoblinsTracks;
						properties.Entities = [];
						properties.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Edge;
						properties.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Random;
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.GoblinRaiders, this.Math.rand(90, 110) * _event.getReputationToDifficultyLightMult(), this.Const.Faction.Enemy);
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.Peasants, this.Math.rand(40, 50) * _event.getReputationToDifficultyLightMult(), this.Const.Faction.PlayerAnimals);
						_event.registerToShowAfterCombat("AftermathC", null);
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
			ID = "AftermathC",
			Text = "[img]gfx/ui/events/event_83.png[/img]{Les restes éparpillés des pauvres voyageurs jonchent le champ de bataille. Un vieil homme vous serre la main.%SPEECH_ON%Merci, monsieur, si vous n\'étiez pas tombé sur nous, nous aurions tous été de la viande verte !%SPEECH_OFF%Mais avant qu\'il ne puisse vous lâcher la main, un autre homme, plus jeune, se précipite vers vous, pointant du doigt.%SPEECH_ON%Au diable ça, vieil homme, j\'ai vu ce salaud sur la colline regarder tout ce temps ! Il nous a laissés dehors comme appât !%SPEECH_OFF%Le vieil homme retire sa main.%SPEECH_ON%Eh bien, je le saurai. Puissiez-vous vivre tous les enfers, mercenaire ! %SPEECH_OFF%Comme si vous vous en foutiez. Vous dites au vieil homme que tout ce que vous trouverez sera à vous. S\'ils veulent protester, ils peuvent trancher leur cou sur une lame.}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Dégagez, paysans.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnPartyDestroyed);
				this.World.Assets.addMoralReputation(-2);
				local food = this.new("scripts/items/supplies/bread_item");
				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "Vous obtenez " + food.getName()
				});
				local item = this.new("scripts/items/weapons/pitchfork");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous obtenez " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_75.png[/img]{D\'une manière ou d\'une autre, ce n\'est pas votre problème. Vous quittez tranquillement la scène, bien que quelques frères soient plutôt troublés que vous ayez laissé ces pauvres paysans à un sort aussi horrible, en particulier lorsque tout le royaume essaie de survivre à ces sauvages verts.}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Passer à autre chose.",
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
					if (this.Math.rand(1, 100) <= 25)
					{
						bro.worsenMood(1.0, "Déçu que vous ayez évité la bataille et laissé les paysans mourir");

						if (bro.getMoodState() <= this.Const.MoodState.Neutral)
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
		if (!this.World.FactionManager.isGreenskinInvasion())
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(currentTile) <= 6)
			{
				return;
			}
		}

		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

