this.oracle_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.oracle";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_11.png[/img]{Vous tombez sur une tente en peau de chèvre au bord de la route. Les bâches en peau ont été trempées dans des teintures violettes, des marguerites fanées sont accrochées aux poils de chèvres, formant des nœuds sans queue ni tête. Une vieille femme bossue se tient dehors, les mains jointes et pendantes. Elle vous regarde de haut en bas avec des yeux flétris.%SPEECH_ON%Ah, un mercenaire. Non, un capitaine de mercenaires. Ou peut-être plus que ça. Vous sentez une odeur étrange, et pas seulement celle d\'un homme. Voulez-vous qu\'on vous dise la bonne aventure?%SPEECH_OFF%Elle fait un geste indiquant l\'intérieur de la tente. Vous voyez un certain nombre de longues cartes posées à plat sur la table.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dites-moi ce qui m'attend, vieille femme.",
					function getResult( _event )
					{
						local r = this.Math.rand(1, 100);

						if (r <= 20 && this.World.getTime().Days > 15)
						{
							return "D";
						}
						else if (r <= 80)
						{
							return "E";
						}
						else
						{
							return "F";
						}
					}

				},
				{
					Text = "Je vais plutôt vous dire la vôtre: Vous êtes sur le point de nous donner tous vos objets de valeur.",
					function getResult( _event )
					{
						local r = this.Math.rand(1, 100);

						if (r <= 50)
						{
							return "B";
						}
						else
						{
							return "C";
						}
					}

				},
				{
					Text = "Non, c\'est bon.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_11.png[/img]{Cette gourde doit avoir pas mal de choses de valeurs depuis le temps, assez pour que vous puissiez vous faire plaisir. Vous ordonnez à la compagnie de fouiller l\'endroit. La femme ne dit rien lorsque vous l\'écartez du chemin, et encre moins lorsque les mercenaires envahissent sa tente et renversent son mât au sol. Elle sourit un peu lorsqu\'ils jettent la bâche en peau de chèvre pour voir le butin, comme des magiciens dévoilant un tour raté. Leurs sourires s\'effacent lorsqu\'ils commencent à fouiller dans ses affaires, leurs bottes écrasant et brisant tout ce qui ne leur est pas utile. La sorcière hausse les épaules et brandit deux cartes qui semblent sorties tout droit de ses manches.%SPEECH_ON%Dites-moi, mercenaire, que voyez-vous?%SPEECH_OFF%Vous jetez un coup d\'œil. Les cartes de tarot représentent un groupe de chevaliers saccageant un village, et une autre représente un cimetière gardé par un gardien particulièrement sévère. Vous haussez les épaules et lui dites qu\'elle garde ce tour de passe-passe comme moyen de défense, une sorcière seule n\'a pas d\'autre solution de toute façon. Vous lui dites qu\'elle a peut-être effrayé quelques voleurs avec ce tour, mais que vous n\'êtes pas né de la dernière pluie. Elle rit.%SPEECH_ON%Vous êtes aussi sage que cruel.%SPEECH_OFF%Exactement. Maintenant, voyons ce que la compagnie a trouvé.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Reprenons la route.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-1);
				local money = this.Math.rand(75, 200);
				this.World.Assets.addMoney(money);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Couronnes"
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_11.png[/img]{Vous regardez attentivement autour de vous. Si la sorcière a préparé une embuscade quelque part, vous ne voyez pas d\'où cela pourrait venir. D\'un geste de la main, vous ordonnez à la compagnie de piller sa propriété. Quelques frères se glissent dans sa tente et commencent à la démolir, retournant les tables et arrachant les tiroirs. La vieille femme fait un pas de côté, et un autre, et encore un autre. Elle... sourit?%SPEECH_ON%Hey, jettez un coup d\'oeil à ce truc!%SPEECH_OFF%Vous vous retournez pour voir l\'un des mercenaires saisir un orbe suspendu au plafond de la tente. Il le décroche d\'un coup sec. La chaîne se tend et on entend le bruit d\'un fil qui se détache. Des étincelles bleues remontent le long de la chaîne et descendent jusqu\'à l\'orbe. Il ne se passe rien. La tente se disloque dans une explosion de flammes bleues, le mât est éjecté loin dans le ciel et les mercenaires titubent, pris dans une fumée chaude. Des marguerites grises et brûlantes virevoltent dans l\'air. Vous protégez vos oreilles pour retrouver l\'ouïe puis vous cherchez la femme du regard mais elle s\'est déjà enfuie. En pinçant vos lèvres, vous vous précipitez pour voir les dégats.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Reprenons la route.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-1);
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 33)
					{
						bro.addLightInjury();
						this.List.push({
							id = 10,
							icon = "ui/icons/days_wounded.png",
							text = bro.getName() + " souffre de blessures légères"
						});
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_11.png[/img]{La tente se referme quand vous entrez. Une lueur orange jaillit d\'une lanterne. En gémissant, la vieille femme utilise cette lumière orangée pour faire apparaître une table et deux chaises. Elle fait un signe vers eux.%SPEECH_ON%Sit.%SPEECH_OFF%Vous vous asseyez. Elle s\'assoit. Elle fait claquer ses lèvres sur ses gencives édentées, hoche la tête et commence à retourner les cartes.%SPEECH_ON%D\'abord, il y a...%SPEECH_OFF%Vous vous penchez en avant pour mieux voir et la table se brise sous votre poids. Les cartes voltigent, la femme tombe à la renverse et la bougie s\'envole. D\'une main, vous attrapez sa canne en plein vol et de l\'autre, vous vous précipitez pour l\'a rattraper. Vous la faites asseoir et lui rendez sa bougie. Elle vous regarde fixement, affichant un sourire aux contours noirs, les yeux plissés.%SPEECH_ON%Oublions ce qui s\'est passé et disons que vous obtenez ce que vous avez toujours voulu avoir, mercenaire, en commençant par ça.%SPEECH_OFF%Elle vous donne un baiser baveux sur le front et vous pousse avec le manche d\'une dague.%SPEECH_ON%Deal!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Quelle femme.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/weapons/named/named_dagger");
				this.World.Assets.getStash().makeEmptySlots(1);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_11.png[/img]{Vous pénétrez dans la tente. %randombrother% regarde à l\'intérieur tandis que les rideaux se referme sur eux. La vieille femme allume une bougie et la porte jusqu\'à son siège. Ironiquement, sa vieille silhouette prend encore plus d\'importance dans l\'obscurité, car les ombres révèlent des crevasses dont vous ne soupçonniez même pas qu\'elles puissent exister sur une personne, et sa peau brille de mille feux. Elle commence immédiatement à retourner les cartes et à parler.%SPEECH_ON%Défaite. Spéculation. Doute.%SPEECH_OFF%Des chevaliers mal peints vont et viennent, leurs membres étant de travers dans des poses bizarres.%SPEECH_ON%Plus de défaite. Mais, aussi, des victoires. Beaucoup de victoires. Vous oubliez la faiblesse. Vous vous lassez de son caractère communicatif. Vous devenez puissant. La force est la survie. Et vous êtes là. Vieux. Vous mourrez.%SPEECH_OFF%Levant un sourcil, vous prenez la dernière carte et la faites glisser dans la lumière. Vous voyez un homme avec une longue barbe grise assis sur une chaise. Vous dites à la femme que vous n\'avez jamais réussi à vous faire pousser une telle barbe, elle éteint la bougie et vous chasse de la tente.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Je devrais arrêter de me raser.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_11.png[/img]{Vous entrez dans la tente, ses plis se referment et vous n\'êtes plus que dans l\'obscurité. Vous restez là un moment et demandez à la femme où elle est allée. Vous vous pincez les lèvres et ouvrez le rabat de la tente pour faire entrer un peu de lumière. Le rayon de lumière fait briller l\'obscurité, vous vous retournez pour voir une dague foncer vers vous. Vous la bloquez avec votre gantelet et dégainez votre épée pour la plonger dans la poitrine de la sorcière. Elle laisse tomber le couteau et s\'accroche à votre épaule.%SPEECH_ON%Quel monstre vous êtes, mercenaire, pour tuer une gentille vieille femme comme moi. Vous allez mourir pour ça. Vous et vos hommes allez tous mourir.%SPEECH_OFF%Vous rapprochez la sorcière de vous et jetez un coup d\'œil à ses yeux de chat soudainement brillants et méchants. Vous crachez et hochez la tête.%SPEECH_ON%Prédire le malheur dans un monde en péril? Ce n\'est pas un travail difficile. Vous savez quel est mon travail, sorcière?%SPEECH_OFF%Son sourire est noir, ses lèvres collantes, du sang noir gicle sur ses lèvres quand elle rit.%SPEECH_ON%Oh, mercenaire ! Nous verrons qui vous êtes vraiment quand Davkul vous aura entre ses mains.%SPEECH_OFF%Le corps de la sorcière devient mou et votre épée traverse soudainement sa peau, laissant la chair tranchée tomber à vos pieds. Vous sortez rapidement de la tente et faites brûler le tout. Certains des hommes jurent qu\'ils peuvent voir le visage de la femme souriant dans les nuages de fumée.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Brûlez la sorcière !",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
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

		if (currentTile.Type == this.Const.World.TerrainType.Snow || currentTile.Type == this.Const.World.TerrainType.SnowyForest)
		{
			return;
		}

		this.m.Score = 5;
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

