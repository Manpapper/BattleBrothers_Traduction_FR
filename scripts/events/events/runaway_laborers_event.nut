this.runaway_laborers_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.runaway_laborers";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 60.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_59.png[/img]Alors que vous marchez le long des routes, une foule d\'hommes à l\'air dépenaillé vous dépasse à toute vitesse. Ils quittent le chemin, sautent dans un talus et se cachent derrière un mur de buissons.\n\nAlors que les buissons se balancent encore, un autre groupe d\'hommes apparaît bientôt. Avant même que le premier homme ne parle, vous savez déjà ce qui va se passer. Apparemment, certains ouvriers se sont mis d\'accord pour abandonner un projet à cause de ce que les surveillants qui les poursuivent qualifient de \"problèmes\". Ils vous demandent si vous avez déjà vu ces puits à ciel ouvert.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Ils sont juste là !",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Nous n\'avons vu personne par ici.",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(1);

						if (this.World.getPlayerRoster().getSize() < this.World.Assets.getBrothersMax())
						{
							return this.Math.rand(1, 100) <= 70 ? "C" : "D";
						}
						else
						{
							return this.Math.rand(1, 100) <= 70 ? "E" : "D";
						}
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_59.png[/img]Les surveillants acquiescent et sortent des gourdins, des fourches et même des filets. Ils quittent la route et se dirigent vers les buissons comme une bande de pillards vers un chariot. C\'est un combat sauvage, bien qu\'à sens unique. Les hommes sont battus et malmenés comme des poissons dans un buisson. Même loin sur le flanc de la colline, on peut entendre le claquement inimitable du bois sur le crâne. On voit un homme mortellement poignardé avec une lance, peut-être la résolution d\'un conflit d\'ordre un peu plus personnel. À la fin de la bataille, le chef des surveillants revient vers vous, avec derrière lui une file de prisonniers à l\'air plutôt mal en point. Il vous tend une bourse de pièces, vous tape sur l\'épaule et vous remercie de garder l\'ordre.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Des couronnes faciles.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-1);
				this.World.Assets.addMoney(50);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]50[/color] Couronnes"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_59.png[/img]Alors que votre doigt pointe toujours du mauvais côté, les surveillants s\'en vont. Leurs aboiements furieux s\'estompent au loin. Quand ils sont partis, les ouvriers émergent lentement. Ils semblent plutôt surpris qu\'un mercenaire n\'ait pas vendu leur position dans les buissons. Un par un, ils enlèvent leurs chapeaux et vous bénissent pour votre clémence. L\'un d\'eux l\'appelle même \"justice\", un mot étrange à l\'oreille d\'un mercenaire. Pendant que la plupart d\'entre eux s\'en vont, un homme reste en retrait. Il demande s\'il peut rejoindre votre compagnie si, vous savez, vous avez de la place pour lui.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bienvenue dans %companyname%!",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						return 0;
					}

				},
				{
					Text = "Ce n\'est pas un endroit pour toi.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx(this.Const.CharacterLaborerBackgrounds);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_59.png[/img]Tous les contremaîtres partent dans la mauvaise direction, sauf un. Il reste immobile sur le bord de la route, regardant le talus. Pendant un bref instant, vous envisagez de lui passer une lame froide sur le cou, faisant sortir les mots de sa gorge au lieu de sa bouche. L\'homme se tourne rapidement vers ses camarades et crie en désignant le bas de la colline. Sentant qu\'ils sont vus, les ouvriers se précipitent hors des buissons, allant dans tous les sens. Ils doivent être sous-alimentés car la plupart d\'entre eux se déplacent à la vitesse d\'un squelette gravissant un escalier\n\nLa bataille qui s\'ensuit est plutôt horrible et injustifiée, les surveillants étant assez punitifs dans leurs méthodes de capture. Lorsque tout est terminé, ils commencent à partir aussi vite qu\'ils sont venus, les ouvriers étant maintenant attachés avec des cordes et leurs têtes couvertes de sacs. Avant de partir, le chef des surveillants vous adresse un mot de mépris. Votre lame sortant lentement de son fourreau, vous demandez à l\'homme s\'il a quelque chose à ajouter. Il crache et secoue la tête pour dire non.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Alors, disparaissez de ma vue !",
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
			Text = "[img]gfx/ui/events/event_59.png[/img]Alors que votre doigt pointe toujours du mauvais côté, les surveillants s\'en vont. Leurs aboiements furieux s\'estompent au loin. Quand ils sont partis, les ouvriers émergent lentement. Ils semblent plutôt surpris qu\'un mercenaire n\'ait pas vendu un mot de leur position parmi les buissons. Un par un, ils enlèvent leurs chapeaux et vous bénissent pour votre clémence. L\'un d\'eux l\'appelle même \"justice\", un mot étrange à l\'oreille d\'un mercenaire.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Adieu.",
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
		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.Const.DLC.Desert && currentTile.SquareCoords.Y <= this.World.getMapSize().Y * 0.2)
		{
			return;
		}

		this.m.Score = 7;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});

