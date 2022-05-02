this.gunpowder_wagon_event <- this.inherit("scripts/events/event", {
	m = {
		Bought = 0
	},
	function create()
	{
		this.m.ID = "event.gunpowder_wagon";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_171.png[/img]{Une série de chameaux apparaît. Ils ont des dizaines de sacoches et de sacs à dos flottant à leurs côtés, et de grands parapluies hissés au-dessus. Les chameaux sont guidés par un jockey singulier monté sur la monture de tête : un vieil homme assis en amazone, un pied dans un étrier et l\'autre en équilibre sur une assiette. Il mange des noix et des baies et savoure une boisson fraîche. Il est perplexe à votre vue.%SPEECH_ON%Mercenaire, oui ? Je peux dire par votre fanfaronnade, les alchimistes fanfarons, transmutant l\'or brut dans le cuivre du sang de son prochain. Je ne te méprise pas, mercenaire, et tu ne me considéreras pas comme la proie du brigandage qui, je le sais, bat bizarrement dans ton cœur.%SPEECH_OFF%Il brandit un bâton avec une marque noire au sommet.%SPEECH_ON%Je porte du salpêtre pour les diverses machines de guerre des vizirs. Voyez-vous, les grands plombs de fonte ne voyagent pas haut et loin sans mon ingrédient, cette douce poussière qui remplit tous les sacs de mes chameaux. Si vous vous considérez comme un voleur courageux, je mettrai le feu à mes marchandises et nous brillerons tous ensemble si fort que le doreur lui-même couvrira ses yeux.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Vendez-vous quelque chose?",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Nous vous laissons à vos voyages.",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_171.png[/img]{Le marchand sourit.%SPEECH_ON%Je suis content que vous ayez demandé car je me lasse parfois de m\'occuper des livrées à plumes des vizirs. Les canailles et les fainéants.%SPEECH_OFF%Il claque des doigts et vous pointe du doigt avec une sincérité paternelle.%SPEECH_ON%La conversation devient vite confabulation. Comme disait mon père, les affaires sont des ballades. Et nous avons tous besoin d\'un peu de poésie dans la monotonie de nos vies.%SPEECH_OFF%Il hoche la tête et parle avec un ton que vous savez qu\'il utilise avec ses collègues marchands.%SPEECH_ON%J\'ai une attente avec les vizirs, mais être volé ou perdre items est aussi une attente de cette attente. Sur ce, j\'ai des choses à offrir qui, si elles sont convenues, me seront \"volées\" à vos frais. Mais vous ne pouvez avoir qu\'une seule de ces disponibilités : un fusil a poudre pour seulement 2 500 couronnes ou une Lance de feu pour seulement 500 couronnes. Vous ne pouvez avoir qu\'un seul des deux proposés.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nous prendrons le fusil a poudre pour 2 500 couronnes.",
					function getResult( _event )
					{
						_event.m.Bought = 1;
						return "C";
					}

				},
				{
					Text = "La lance de feu à 500 couronnes c\'est sûr.",
					function getResult( _event )
					{
						_event.m.Bought = 2;
						return "C";
					}

				},
				{
					Text = "Pour ce prix, aucun n\'a d\'intérêt.",
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
			ID = "C",
			Text = "[img]gfx/ui/events/event_171.png[/img]{Vous et le marchand parvenez à un accord sur les articles. Après avoir échangé des pièces et des marchandises, il remonte sur son chameau et vous fait un pied de nez.%SPEECH_ON%Je suis vraiment désolé d\'avoir été volé, cette journée a vraiment été horrible. Malheur, les vizirs seront aussi tristes que moi.%SPEECH_OFF%Le marchand se remet en amazone et commence à se régaler de ses baies et de ses noix. Il ne prend pas ses rênes, pourtant les chameaux semblent bouger comme sur commande.%SPEECH_ON%Puisse ton chemin être toujours doré, mercenaire, et que mes biens abrogés te procurent l\'éclat que tu recherches.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Et puissiez-vous aussi trouver l\'éclat.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				switch(_event.m.Bought)
				{
				case 1:
					local item = this.new("scripts/items/weapons/oriental/handgonne");
					this.World.Assets.getStash().add(item);
					this.List.push({
						id = 10,
						icon = "ui/items/" + item.getIcon(),
						text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
					});
					item = this.new("scripts/items/ammo/powder_bag");
					this.World.Assets.getStash().add(item);
					this.List.push({
						id = 10,
						icon = "ui/items/" + item.getIcon(),
						text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
					});
					this.World.Assets.addMoney(-2500);
					this.List.push({
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "You spend [color=" + this.Const.UI.Color.NegativeEventValue + "]2500[/color] Couronnes"
					});
					break;

				case 2:
					local item = this.new("scripts/items/weapons/oriental/firelance");
					this.World.Assets.getStash().add(item);
					this.List.push({
						id = 10,
						icon = "ui/items/" + item.getIcon(),
						text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
					});
					this.World.Assets.addMoney(-500);
					this.List.push({
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "You spend [color=" + this.Const.UI.Color.NegativeEventValue + "]500[/color] Couronnes"
					});
					break;
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_171.png[/img]{Le marchand tend les mains comme si vous le voliez.%SPEECH_ON%Ce n\'est pas grave si vous ne souhaitez pas avoir mes biens, vraiment.%SPEECH_OFF%Il croise les jambes pour s\'asseoir à nouveau en amazone et les chameaux commencent immédiatement à déplacer comme si c\'était leur ordre. Le marchand parle en mangeant ses noix et ses baies.%SPEECH_ON%Puisse ton chemin être toujours doré, mercenaire, et que les vizirs de ces déserts te mettent à profit.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "J\'espère qu\'ils le font aussi.",
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
			ID = "E",
			Text = "[img]gfx/ui/events/event_171.png[/img]{Vous acquiescez et souhaitez bonne chance à l\'homme dans ses voyages. Il s\'incline respectivement.%SPEECH_ON%Que votre chemin soit toujours doré, mercenaire.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Comme le vôtre.",
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
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (this.World.FactionManager.isHolyWar())
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Desert && currentTile.TacticalType != this.Const.World.TerrainTacticalType.DesertHills && currentTile.Type != this.Const.World.TerrainType.Oasis)
		{
			return;
		}

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.World.Assets.getMoney() < 2500)
		{
			return;
		}

		if (this.World.Assets.getStash().getNumberOfEmptySlots() < 1)
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
		this.m.Bought = 0;
	}

});

