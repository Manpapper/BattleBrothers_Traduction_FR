this.undead_frozen_pond_event <- this.inherit("scripts/events/event", {
	m = {
		Lightweight = null,
		Other = null
	},
	function create()
	{
		this.m.ID = "event.undead_frozen_pond";
		this.m.Title = "Sur le chemin...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_143.png[/img]En traversant les déserts froids, vous arrivez au bord d\'un étang gelé. %randombrother% repère quelque chose qui dépasse en son milieu. Vous voyez que c\'est un chevalier dont le corps a été gelé jusqu\'aux hanches, mais le haut du corps bouge encore. Les yeux brillent de rouge et ses doigts, noirs de jais à cause des engelures, parviennent toujours à se serrer et à s\'agripper. Sa mâchoire est maintenue par de la glace pour les muscles, comme avec des tendons en décomposition et translucides.\n\n %randombrother% pointe vers le wiederganger géant au visage gelé.%SPEECH_ON%Hé, regarde ! Ce connard a une grosse épée sur lui. Cela vaut peut-être la peine d\'essayer, non ?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Des volontaires?",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "Good";
						}
						else
						{
							return "Bad";
						}
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Lightweight != null)
				{
					this.Options.push({
						Text = "Tu es rapide sur tes pieds, %lightweightfull%. Essaie?",
						function getResult( _event )
						{
							return "Lightweight";
						}

					});
				}

				this.Options.push({
					Text = "Ça ne vaut pas le coup.",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "Good",
			Text = "[img]gfx/ui/events/event_143.png[/img]%chosenbrother% choisit d\'essayer de tenter de récupérer l\'épée du chevalier mort. Son premier pas sur l\'étang envoie un craquement clair et glacial. Il teste à nouveau son pied. La glace bouge et grince, mais elle ne cède pas. À chaque pas, le mercenaire mesure son propre poids et sa probabilité de passer à travers la glace - tout en s\'assurant qu\'il ne marche pas sur l\'un des cadavres éparpillés. \n\n Il réussit à atteindre le chevalier mort-vivant. Des glaçons pendent de son épée, la lame elle-même encapsulée dans une couche de glace. Le mercenaire attrape la lame et tire. Le bras du chevalier mort-vivant fait une embardée vers l\'avant et se brise au niveau du coude, envoyant le mercenaire patiner le cul en l\'air à travers l\'étang. Il glisse contre le bord où vos hommes l\'aident à se relever. L\'épée devra être chauffée pour enlever la glace, mais l\'arme est définitivement utilisable.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bien joué.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Other.getImagePath());
				local item = this.new("scripts/items/weapons/greatsword");
				item.setCondition(11.0);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous obtenez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Bad",
			Text = "[img]gfx/ui/events/event_143.png[/img]%chosenbrother% teste la glace en posant un pied sur le bord de l\'étang. Un gazouillis doux résonne sur le ventre froid de l\'eau du bassin, comme si quelqu\'un avait lancé un rocher tambourinant sur une surface arrondi. Il se retourne vers la compagnie et hausse les épaules.%SPEECH_ON%Ça va.%SPEECH_OFF%Sa prochaine étape l\'envoie s\'écraser sur la glace. Les éclats de glaces se brisent en une sorte de piège à chevrons et quand il tend la main pour en attraper un, il se tranche les mains. Les hommes lui lancent rapidement une corde et le traînent dehors.\n\n Ensanglanté et frissonnant, %chosenbrother% secoue la tête alors qu\'il est enveloppé dans des couvertures.%SPEECH_ON%I-I-I-Je crois que c\'était aw-aw-aw-aw-aw-aw-aw-aw-aw-aw-aw-aw-aw-aw-aw-aw-aw-aw-aw-aw-aw-aw. Aaaaaaaaaaaaaaareuse idée, monsieur.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Tu as fait de ton mieux.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Other.getImagePath());
				local injury = _event.m.Other.addInjury([
					{
						ID = "injury.split_hand",
						Threshold = 0.5,
						Script = "injury/split_hand_injury"
					}
				]);
				this.List = [
					{
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.Other.getName() + " souffre " + injury.getNameOnly()
					}
				];
				local effect = this.new("scripts/skills/injury/sickness_injury");
				_event.m.Other.getSkills().add(effect);
				this.List.push({
					id = 10,
					icon = effect.getIcon(),
					text = _event.m.Other.getName() + " est malade"
				});
			}

		});
		this.m.Screens.push({
			ID = "Lightweight",
			Text = "[img]gfx/ui/events/event_143.png[/img]%lightweight%avance.%SPEECH_ON%Glace ? La glace n\'est rien. Vous pouvez glisser dessus comme ceci.%SPEECH_OFF%Sans même une pause, l\'homme saute sur l\'étang gelé et patine sur sa surface. Des fissures émergent de derrière lui comme un sillage de mauvaise augure, mais il reste imperturbable. Il se balance près du chevalier mort-vivant et attrape l\'épée gelée. Le wiederganger gémit lorsque son bras se brise au niveau du coude. L\'homme patine joyeusement vers le bord de l\'étang et vous présente l\'épée. %otherbrother% s\'avance et fait tomber le bras gelé du wiederganger de la poignée comme un homme cassant une pince de crabe.%SPEECH_ON%Voudriez-vous regarder ça ?%SPEECH_OFF%Il écrase les doigts en morceaux et dans les restes en poudre il y a une chevalière. Une épée et des bijoux, qu\'est-ce qu\'il n\'y a pas à aimer dans ce résultat ?",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Impressionnant.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Lightweight.getImagePath());
				local item = this.new("scripts/items/weapons/greatsword");
				item.setCondition(11.0);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous obtenez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/loot/signet_ring_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous obtenez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.FactionManager.isUndeadScourge())
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Snow)
		{
			return;
		}

		if (currentTile.HasRoad)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(currentTile) <= 6)
			{
				nearTown = true;
				break;
			}
		}

		if (nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_lightweight = [];
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getCurrentProperties().getInitiative() >= 130)
			{
				candidates_lightweight.push(bro);
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

		this.m.Lightweight = candidates_lightweight[this.Math.rand(0, candidates_lightweight.len() - 1)];
		this.m.Other = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 20;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"chosenbrother",
			this.m.Other.getNameOnly()
		]);
		_vars.push([
			"otherbrother",
			this.m.Other.getNameOnly()
		]);
		_vars.push([
			"lightweight",
			this.m.Lightweight != null ? this.m.Lightweight.getNameOnly() : ""
		]);
		_vars.push([
			"lightweightfull",
			this.m.Lightweight != null ? this.m.Lightweight.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Lightweight = null;
		this.m.Other = null;
	}

});

