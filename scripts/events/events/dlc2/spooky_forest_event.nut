this.spooky_forest_event <- this.inherit("scripts/events/event", {
	m = {
		Brave = null,
		Lumberjack = null
	},
	function create()
	{
		this.m.ID = "event.spooky_forest";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_25.png[/img]Alors que vous campez dans les bois, %randombrother% vous appelle hors de la tente de commandement. Vous demandez ce qu\'il veut, il met un doigt sur ses lèvres en signe de silence. Il désigne un arbre qui s\'élève dans l\'obscurité de la nuit. On entend des craquements comme si quelque chose faisait un nid à partir de grosses branches. Vous entendez des gloussements, des reniflements, puis des ricanements gutturaux, dignes d\'un oiseau qui crie au secours depuis le ventre d\'un serpent. Lorsque vous baissez les yeux, les hommes vous regardent fixement, cherchant une idée sur la façon de réagir à cet événement.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C'est juste un animal. Retournez au travail.",
					function getResult( _event )
					{
						return "WalkOff";
					}

				},
				{
					Text = "Mieux vaut prévenir que guérir. On va couper l\'arbre.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "CutdownGood";
						}
						else
						{
							return "CutdownBad";
						}
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Lumberjack != null)
				{
					this.Options.push({
						Text = "%lumberjack%, vous savez comment abattre les arbres. Faites-le.",
						function getResult( _event )
						{
							return "Lumberjack";
						}

					});
				}

				if (_event.m.Brave != null)
				{
					this.Options.push({
						Text = "%bravebro%, vous êtes le plus courageux du lot. Allez voir de quoi il s\'agit.",
						function getResult( _event )
						{
							return "Brave";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Lumberjack",
			Text = "[img]gfx/ui/events/event_25.png[/img]Vous ordonnez à %lumberjack%, le bûcheron, d\'abattre l\'arbre. Il acquiesce et se met au travail en utilisant une foule d\'outils disponibles, qui ne sont forcement des haches. Il entaille le bois d\'un côté et bloque les interstices avec la poignée de diverses armes, puis va de l\'autre côté et coupe le tronc. Il bosse avec une aisance que vous aimeriez voir sur le champ de bataille. C\'est le genre d\'authenticité que l\'on voit rarement dans la vie, un homme et son travail. Il a les yeux fixés sur le dessin d\'un avenir certain, des mains destinées à effectuer cette tâche.%SPEECH_ON%Ay-yo!%SPEECH_OFF%Il crie et l\'arbre est abattu. Il se fissure, craque, pour finalement s\'incliner et frapper le sol si fort qu\'il semble faire mal à la terre elle-même. Dégainant votre épée, vous allez enquêter au niveau la cime de l\'arbre abattu. Vous y trouvez une paire de Nachzehrers, écrasés, les dents tombées sur le sol de la forêt comme des champignons sans chapeau. Les craintes de la compagnie sont dissipées par cette vision macabre.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ce mystère est donc résolu.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Lumberjack.getImagePath());
				local item = this.new("scripts/items/misc/ghoul_teeth_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Brave",
			Text = "[img]gfx/ui/events/event_25.png[/img]%bravebro%, le courageux soldat, grimpe dans l\'arbre à une vitesse qui ne laisse pas de place à la peur ou la réticence. C\'est comme si il avait vu passer une jeune fille au loin. Il vient tout juste de partir et, malgré cela, \'n\' son ascension bruyante est immanquable. Finalement, vous l\'entendez revenir, le bruit de sa descente s\'arrêtant et repartant au fur et à mesure qu\'il trouve un terrain sûr. Vous le voyez revenir dans votre champ de vision, les semelles de ses bottes apparaissant d\'abord comme des plaquettes de beurre suspendues dans le noir. Sa silhouette ombrageuse glisse toujours vers le bas jusqu\'à ce qu\'il fasse un dernier bond pour atteindre le sol. Il fait une roulade pour assurer son atterrissage puis se relève.%SPEECH_ON%Il y avait un ours noir la tête enfoncée dans un nid d\'abeille, mais la bête était morte depuis au moins deux jours. J\'ai vu un groupe de chauves-souris s\'échapper quand je me suis approché, je pense qu\'elles mangeaient ses entrailles. Ça a dégringolé quand elles se sont enfuies.%SPEECH_OFF%Il se retourne et jette une épée sur le sol. Elle est couverte de miel et d\'aiguilles de pin, mais sinon, elle a l\'air d\'une lame remarquable.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Voyons cette lame.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Brave.getImagePath());
				local item = this.new("scripts/items/weapons/arming_sword");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez an " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "CutdownGood",
			Text = "[img]gfx/ui/events/event_25.png[/img]Vous demandez à la compagnie d\'abattre l\'arbre. Ils s\'attellent à la tâche, bien qu\'ils aient peu d\'expérience en la matière, le résultat final est une course effrénée pour se mettre à l\'abri lorsque le tronc s\'abat dans une direction inattendue. Un ours noir effrayé s\'élance depuis la cime de l\'arbre. Il a un museau en forme de nid d\'abeille et s\'enfonce dans l\'obscurité de la forêt.\n\n Personne n\'est écrasé, mais le chaos et les débris laissent quelques hommes dans un sale état.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Eh bien, c\'était un effort qui en valait la peine...",
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
					if (bro.getSkills().hasSkill("trait.swift") || bro.getSkills().hasSkill("trait.sure_footed") || bro.getSkills().hasSkill("trait.lucky") || bro.getSkills().hasSkill("trait.quick"))
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 20)
					{
						bro.addLightInjury();
						this.List.push({
							id = 10,
							icon = "ui/icons/days_wounded.png",
							text = bro.getName() + " suffers light wounds"
						});
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "CutdownBad",
			Text = "[img]gfx/ui/events/event_25.png[/img]Vous ordonnez aux hommes d\'abattre l\'arbre. %randombrother% commence avec un coup sec muni d\'un objet plat. Il pose un pied sur le tronc pour libérer l\'objet et c\'est à peu près la dernière fois que vous le voyez car il s\'envole. Une branche d\'arbre revient à sa position initiale accompagné d\'un long gémissement émanant du tronc, comme si l\'arbre réclamait une partie de son corps. Vous regardez l\'arbre se détacher du sol et se déraciner. Des yeux d\'émeraude s\'enflamment et s\'élargissent, leurs regards étant entrecoupés par la chute des feuilles.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C'est quoi ce bordel!",
					function getResult( _event )
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.BeastsTracks;
						properties.Entities = [];
						properties.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.Schrats, this.Math.rand(90, 110), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID());
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
			ID = "WalkOff",
			Text = "[img]gfx/ui/events/event_25.png[/img]Vous ne pouvez pas être dérangé par une telle absurdité. Il est probable que ce soit un lynx ou un aigle en quelque sorte. Si c\'est pire, il descendra et la compagnie s\'en occupera à ce moment-là. Cette façon de penser ne convient pas à certains hommes.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ce n\'est qu'un animal...",
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
						bro.worsenMood(0.5, "Concerned that you didn\'t act on a possible threat");

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
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.LeaveForest)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(currentTile) <= 15)
			{
				return;
			}
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_lumberjack = [];
		local candidates_brave = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.lumberjack")
			{
				candidates_lumberjack.push(bro);
			}
			else if (bro.getSkills().hasSkill("trait.brave") || bro.getSkills().hasSkill("trait.fearless"))
			{
				candidates_brave.push(bro);
			}
		}

		if (candidates_lumberjack.len() != 0)
		{
			this.m.Lumberjack = candidates_lumberjack[this.Math.rand(0, candidates_lumberjack.len() - 1)];
		}

		if (candidates_brave.len() != 0)
		{
			this.m.Brave = candidates_brave[this.Math.rand(0, candidates_brave.len() - 1)];
		}

		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"lumberjack",
			this.m.Lumberjack ? this.m.Lumberjack.getNameOnly() : ""
		]);
		_vars.push([
			"bravebro",
			this.m.Brave ? this.m.Brave.getNameOnly() : ""
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Lumberjack = null;
		this.m.Brave = null;
	}

});

