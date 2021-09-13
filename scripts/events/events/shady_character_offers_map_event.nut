this.shady_character_offers_map_event <- this.inherit("scripts/events/event", {
	m = {
		Historian = null,
		Thief = null,
		Peddler = null,
		Cost = 0,
		PricePaid = 0,
		Location = null
	},
	function create()
	{
		this.m.ID = "event.shady_character_offers_map";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_41.png[/img]Alors que vous marchez, un marchand solitaire avec son cheval de trait apparaît sur votre chemin. Il a les bras tendus et les mains visibles.%SPEECH_ON%Bonsoir, voyageurs. Puis-je vous proposer quelques marchandises ? %SPEECH_OFF%Il énumère un certain nombre de choses dont %companyname% ne pourrait avoir l\'utilité, mais il mentionne ensuite une carte. Vous avez dû lever un sourcil, car il lève le sien et sourit.%SPEECH_ON%Ah, vous vous intéressez cette carte ? Cette bizarrerie cartographique, topographique, géographique, portée par un homme qui, je vous l\'assure, est très sensé ! Ce papier vous indique l\'emplacement exact du fameux \"%location%\". Je suis sûr que vous en avez entendu parler, non ? Il abrite des trésors inestimables ! Lieu de repos de certaines des plus belles armes du monde ! Et tout ce que cela vous coûtera, c\'est un maigre  versement  de %mapcost% couronnes!%SPEECH_OFF%Il tourne la tête avec un long sourire. Il semble qu\'il ait vendu certaines de ses dents pendant ses jours sur la route.%SPEECH_ON%Alors, voyageurs, qu\'en dites-vous ?%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Je suis intriguée, nous allons acheter la carte.",
					function getResult( _event )
					{
						this.World.Assets.addMoney(-_event.m.Cost);
						_event.m.PricePaid = _event.m.Cost;

						if (_event.m.Historian != null)
						{
							return "B";
						}
						else
						{
							return this.Math.rand(1, 100) <= 50 ? "C" : "D";
						}
					}

				},
				{
					Text = "Not interested.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Peddler != null)
				{
					this.Options.push({
						Text = "%peddler%, tu étais un colporteur avant. Obtiens-nous une meilleure offre !",
						function getResult( _event )
						{
							return "E";
						}

					});
				}

				if (_event.m.Thief != null)
				{
					this.Options.push({
						Text = "%thief%, tu étais un voleur avant. Obtiens-nous cette carte !",
						function getResult( _event )
						{
							return "F";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_45.png[/img]Ayant acquis la carte, vous l\'examinez longuement. Vous sortez votre propre carte et commencez à regarder les deux. Il n\'y a rien sur la carte achetée qui puisse être recoupé. En fait, la carte que vous avez achetée a des runes étranges griffonnées sur les bords. Soit c\'est une contrefaçon récente, soit elle provient d\'une époque où la langue commune n\'était pas la vôtre. Dans tous les cas, elle semble inutilisable.\n\n Au moment où vous vous apprêtez à le mettre en boule et à le jeter, %historian% l\'historien s\'approche et le prend doucement. Il regarde les runes et commence à hocher la tête, passant son doigt le long des bords avant de les ramener vers l\'intérieur, parmi les montagnes, les rivières et les forêts mal dessinées de la carte.%SPEECH_ON%Hmmm... Oh... Ah oui, j\'ai déjà entendu parler de cet endroit. Et je connais ces runes, même si je n\'ose pas les dire à haute voix.%SPEECH_OFF%Il prend la carte de la compagnie et utilise trois plumes d\'oie coincées entre ses doigts pour trianguler et traduire lentement les directions. Une fois terminé, il hoche la tête et frappe du dos de sa main la carte de la compagnie.%SPEECH_ON%Là, monsieur. C\'est là que nous le trouverons.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C\'est bien d\'avoir quelqu\'un avec vos compétences parmi nous.",
					function getResult( _event )
					{
						this.World.uncoverFogOfWar(_event.m.Location.getTile().Pos, 700.0);
						_event.m.Location.getFlags().set("IsEventLocation", true);
						_event.m.Location.setDiscovered(true);
						this.World.getCamera().moveTo(_event.m.Location);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Historian.getImagePath());

				if (_event.m.PricePaid != 0)
				{
					this.List.push({
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Vous dépensez[color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.PricePaid + "[/color] Couronnes"
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_45.png[/img]Vous prenez la carte et la lisez attentivement. Vous pouvez identifier certains des emplacements et, avec le temps, transposer son contenu sur votre propre carte. %companyname% murmure avec excitation sur ce qui pourrait se trouver là.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Réclamons-le pour la compagnie !",
					function getResult( _event )
					{
						this.World.uncoverFogOfWar(_event.m.Location.getTile().Pos, 700.0);
						_event.m.Location.getFlags().set("IsEventLocation", true);
						_event.m.Location.setDiscovered(true);
						this.World.getCamera().moveTo(_event.m.Location);
						return 0;
					}

				}
			],
			function start( _event )
			{
				if (_event.m.PricePaid != 0)
				{
					this.List.push({
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Vous dépensez [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.PricePaid + "[/color] Couronnes"
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_45.png[/img]Vous regardez la carte, vous la fixez, vous l\'interrogez pratiquement d\'un long, long regard. Mais vous ne la voyez pas. %randombrother% y jetes un long regard et secoue la tête.%SPEECH_ON%Je n\'en reconnais pas une miette, monsieur...%SPEECH_OFF% C\'est un fausse carte ou une carte d\'un pays que vous ne reconnaissez pas comme le vôtre - dans tous les cas, c\'est complètement inutile.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "On s\'est fait avoir.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				if (_event.m.PricePaid != 0)
				{
					this.List.push({
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Vous dépensez [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.PricePaid + "[/color] Couronnes"
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_41.png[/img]%peddler% le colporteur s\'avance, les mains tendues comme l\'avait été celles du marchand ambulant. Apparemment, c\'est une tactique courante chez les honnêtes voleurs.%SPEECH_ON%Monsieur, monsieur, s\'il vous plaît. Je vous en prie. Ce prix est scandaleux.%SPEECH_OFF% Le visage du marchand s\'empourpre.%SPEECH_ON% Il n\'y a rien de scandaleux là-dedans, je vous le promets.%SPEECH_OFF% Mais votre colporteur persiste.%SPEECH_ON% Il y a clairement quelque chose de scandaleux, parce que je viens de le dire, n\'est-ce pas?%SPEECH_OFF% Le marchand acquiesce. Le colporteur continue. %SPEECH_ON% Donc nous avons décidé de ne pas l\'acheter à votre prix initial. C\'est clair. Alors, mon ami, je pense que nous allons l\'acheter pour %newcost%. C\'est équitable pour toutes les parties concernées, et un homme d\'affaires tel que vous peut sûrement trouver un accord ! Nous ne sommes pas des hommes d\'affaires nous-mêmes, mais nous savons que c\'est une bonne affaire !%SPEECH_OFF% Le marchand se gratte le menton, puis hoche la tête.%SPEECH_ON%Très bien, ce prix est honnête%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Une meilleure affaire !",
					function getResult( _event )
					{
						this.World.Assets.addMoney(-_event.m.Cost / 2);
						_event.m.PricePaid = _event.m.Cost / 2;

						if (_event.m.Historian != null)
						{
							return "B";
						}
						else
						{
							return this.Math.rand(1, 100) <= 50 ? "C" : "D";
						}
					}

				},
				{
					Text = "Still not worth it.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Peddler.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_41.png[/img]Pendant que vous parlez au marchand, %thief% le voleur s\'approche de vous, semblant plutôt intéressé par la conversation. Il vous jette un coup d\'œil. Vous faites un signe. Il sourit et acquiesce. Vous regardez rapidement le vendeur, puis vous vous retournez vers le voleur et hochez la tête. Le marchand est en plein milieu de son discours de vente et ne voit rien de tout cela. Il continue de parler, mais vous n\'entendez pas grand-chose. Vous savez juste qu\'il faut continuer à hocher la tête car un marchand comme lui ne vous dit que des choses que vous voulez entendre de toute façon.\n\nLe voleur se glisse par l\'arrière et laisse tomber une arme dans la boue. %SPEECH_ON%Quel maladroit.%SPEECH_OFF%Il se baisse, fait une pause, il y a un mouvement que vous pouvez à peine détecter, puis il se redresse. Il vous fait un clin d\'œil. Vous dites au marchand que vous appréciez l\'offre, mais que vous devez passer votre tour. Quand il est parti, %thief% vous remet la carte et sourit. %SPEECH_ON%On dit que les meilleures choses dans la vie sont gratuites. %SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ça, c\'est ce que j\'appelle une affaire.",
					function getResult( _event )
					{
						if (_event.m.Historian != null)
						{
							return "B";
						}
						else
						{
							return this.Math.rand(1, 100) <= 50 ? "C" : "D";
						}
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Thief.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.getTime().Days < 10)
		{
			return;
		}

		if (this.World.Assets.getMoney() <= 1500)
		{
			return;
		}

		if (this.World.State.getEscortedEntity() != null)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		local bases = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getSettlements();
		local candidates_location = [];

		foreach( b in bases )
		{
			if (!b.getLoot().isEmpty() && !b.getFlags().get("IsEventLocation"))
			{
				candidates_location.push(b);
			}
		}

		if (candidates_location.len() == 0)
		{
			return;
		}

		this.m.Location = candidates_location[this.Math.rand(0, candidates_location.len() - 1)];
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_peddler = [];
		local candidates_thief = [];
		local candidates_historian = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.historian")
			{
				candidates_historian.push(bro);
			}
			else if (bro.getBackground().getID() == "background.thief")
			{
				candidates_thief.push(bro);
			}
			else if (bro.getBackground().getID() == "background.peddler")
			{
				candidates_peddler.push(bro);
			}
		}

		if (candidates_historian.len() != 0)
		{
			this.m.Historian = candidates_historian[this.Math.rand(0, candidates_historian.len() - 1)];
		}

		if (candidates_thief.len() != 0)
		{
			this.m.Thief = candidates_thief[this.Math.rand(0, candidates_thief.len() - 1)];
		}

		if (candidates_peddler.len() != 0)
		{
			this.m.Peddler = candidates_peddler[this.Math.rand(0, candidates_peddler.len() - 1)];
		}

		this.m.Cost = this.Math.rand(6, 14) * 100;
		this.m.Score = 7;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"historian",
			this.m.Historian != null ? this.m.Historian.getNameOnly() : ""
		]);
		_vars.push([
			"peddler",
			this.m.Peddler != null ? this.m.Peddler.getNameOnly() : ""
		]);
		_vars.push([
			"thief",
			this.m.Thief != null ? this.m.Thief.getNameOnly() : ""
		]);
		_vars.push([
			"location",
			this.m.Location.getName()
		]);
		_vars.push([
			"mapcost",
			this.m.Cost
		]);
		_vars.push([
			"newcost",
			this.m.Cost / 2
		]);
	}

	function onClear()
	{
		this.m.Historian = null;
		this.m.Thief = null;
		this.m.Peddler = null;
		this.m.Location = null;
	}

});

