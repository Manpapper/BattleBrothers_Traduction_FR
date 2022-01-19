this.civilwar_treasurer_event <- this.inherit("scripts/events/event", {
	m = {
		NobleHouse = null
	},
	function create()
	{
		this.m.ID = "event.crisis.civilwar_treasurer";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_72.png[/img]En parcourant les terres, vous tombez sur un fermier accosté par un homme à l\'air aisé. En vous voyant, le fermier crie rapidement.%SPEECH_ON%Monsieur, aidez-moi ! Ce trésorier veut prendre mes récoltes !%SPEECH_OFF%Le trésorier hoche la tête, apparemment comme si aucun crime n\'était commis ici.%SPEECH_ON%C\'est exact. J\'ai été envoyé par %noblehouse% et je suis ici pour collecter des réserves de nourriture pour l\'armée. C\'est notre terre, et donc nos récoltes.%SPEECH_OFF%La situation de la guerre s\'aggrave constamment... %randombrother% vous demande ce que vous voulez faire.",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Laissez ce fermier tranquille !",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Ce n\'est pas notre affaire.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Dehors, tous les deux. Cette nourriture est maintenant la nôtre !",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_72.png[/img]Bien que la morale ait peu de poid dans le jeu de la guerre, vous ne pouvez pas vous empêcher de penser que ce pauvre fermier n\'a rien fait de mal. Vous attrapez le trésorier par sa chemise et le pressez contre un mur. Ses yeux s\'écarquillent, comme si vous veniez de percer un voile d\'invincibilité.%SPEECH_ON%Qu\'est-ce que vous pensez faire ?%SPEECH_OFF%Vous desserrez votre prise, car même si cet homme n\'est peut-être pas invincible, son nom a du soutien.%SPEECH_ON%Dites à vos hommes que ce fermier n\'avait rien à offrir. Les récoltes étaient mauvaises cette saison, compris ?%SPEECH_OFF%Vous avez mis une main sur le pommeau de votre épée. L\'homme y jette un coup d\'oeil, puis acquiesce rapidement.%SPEECH_ON%D\'accord, j\'ai compris.%SPEECH_OFF%Le fermier vous remercie du fond du coeur, et aussi un peu du fond de ses stocks, vous récompensant avec quelques sacs de céréales pour votre aide.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "On a fait le bien aujourd\'hui.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Vous avez menacé un de leurs trésoriers");
				this.World.Assets.addMoralReputation(1);
				local food = this.new("scripts/items/supplies/ground_grains_item");
				this.World.Assets.getStash().add(food);
				this.World.Assets.updateFood();
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "Vous obtenez " + food.getName()
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.farmhand" && this.Math.rand(1, 100) <= 50)
					{
						bro.improveMood(0.25, "Vous avez aidé un agriculteur en péril");

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
			ID = "C",
			Text = "[img]gfx/ui/events/event_72.png[/img]Bien que vous vous sentiez mal pour le fermier, les sentiments ne valent pas grand-chose lorsqu\'il y a une grande guerre entre les maisons nobles. Vous choisissez de ne pas vous impliquer. Alors que les hommes de mains du trésorier transportent les sacs de céréales sur un chariot, il vient discuter.%SPEECH_ON%Je dirai à la noblesse de votre, eh bien, noble décision ici. Vous auriez pu faire opposition, mais vous ne l\'avez pas fait. Merci, mercenaire. Les hommes de notre armée avaient besoin de cette nourriture plus que vous ne pouvez l\'imaginer.%SPEECH_OFF%",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Tant pis.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Vous avez respecté l\'autorité d\'un de leurs trésoriers");
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_72.png[/img]Au départ, il semblait qu\'il y avait deux options ici, mais en tant que mercenaire libre des contracts de la noblesse, de la responsabilité et de toute sorte de carcan social, vous choisissez un troisième angle : prendre la nourriture pour vous et vos hommes. Le trésorier et le fermier protestent tous les deux, mais vos hommes tirent leurs lames, ce qui est un moyen rapide de faire taire toute sorte de débat.\n\n Au total, il n\'y a vraiment pas grand-chose à prendre et vous subissez l\'ire du paysan ainsi que la noblesse pour la peine.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Nous devons d\'abord faire attention à nous.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Vous avez menacé un de leurs trésoriers");
				this.World.Assets.addMoralReputation(-2);
				local maxfood = this.Math.rand(2, 3);

				for( local i = 0; i < maxfood; i = ++i )
				{
					local food = this.new("scripts/items/supplies/ground_grains_item");
					this.World.Assets.getStash().add(food);
					this.World.Assets.updateFood();
					this.List.push({
						id = 10,
						icon = "ui/items/" + food.getIcon(),
						text = "Vous obtenez " + food.getName()
					});
				}
			}

		});
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

		local playerTile = this.World.State.getPlayer().getTile();
		local towns = this.World.EntityManager.getSettlements();
		local bestDistance = 9000;
		local bestTown;

		foreach( t in towns )
		{
			local d = playerTile.getDistanceTo(t.getTile());

			if (d <= bestDistance)
			{
				bestDistance = d;
				bestTown = t;
				break;
			}
		}

		if (bestTown == null)
		{
			return;
		}

		this.m.NobleHouse = bestTown.getOwner();
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"noblehouse",
			this.m.NobleHouse.getName()
		]);
	}

	function onClear()
	{
		this.m.NobleHouse = null;
	}

});

