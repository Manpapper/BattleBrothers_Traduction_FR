this.merchant_of_jugs_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.merchant_of_jugs";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_171.png[/img]{Un marchand solitaire s\'approche avec un chariot tiré par un chameau. De grandes cruches cliquettent les unes contre les autres dans le lit de son chariot, des cordes de mousse séchée étant suspendues entre les couvercles de chacune d\'elles. Il se redresse sur le chameau et balance ses jambes d\'un côté du garrot de l\'animal, en tapant sur sa propre botte avec un interrupteur de jockey.%SPEECH_ON%Bonjour, voyageurs, je prie pour que votre route vers la pièce ait été bien dorée. La mienne l\'a été, bien que je craigne que nos chemins se soient apparemment croisés à un moment où ma spécialitée brille en nombre rare. Il ne me reste que quelques marchandises, toutes à boire. 50 couronnes par cruche. Intéressé?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nous prenons toutes les cruches pour 150 couronnes.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Pour 50 couronnes, nous n\'en prendrons qu\'une.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Nous sommes bons.",
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
			Text = "[img]gfx/ui/events/event_171.png[/img]{Vous lui demandez tout ce qu\'il a, ce que le marchand fait avec plaisir. Lorsqu\'il part, ses chameaux sont vides et semblent plus léger après avoir porté une charge pendant si longtemps. La boisson contenue dans les cruches est un mélange d\'eau et d\'autres additifs qui garantissent un goût bon et durable. Une boisson rafraîchissante à déguster dans un désert infernal.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Comme c\'est rafraîchissant !",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(-150);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous dépensez [color=" + this.Const.UI.Color.NegativeEventValue + "]150[/color] Couronnes"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				for( local i = 0; i < 3; i = ++i )
				{
					foreach( bro in brothers )
					{
						if (this.Math.rand(1, 100) <= 33)
						{
							bro.improveMood(1.0, "J\'ai bu une boisson très rafraîchissante");

							if (bro.getMoodState() > this.Const.MoodState.Neutral)
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
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_171.png[/img]{Le marchand acquiesce et vous échangez des couronnes contre l\'une des cruches. Bien que vous n\'ayez qu\'une seule cruche de cette boisson, elle vous apportera un répit rafraîchissant dans la chaleur infernale du désert.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Comme c\'est rafraîchissant !",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(-50);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous dépensez [color=" + this.Const.UI.Color.NegativeEventValue + "]50[/color] Couronnes"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 33)
					{
						bro.improveMood(1.0, "J\'ai bu une boisson très rafraîchissante");

						if (bro.getMoodState() > this.Const.MoodState.Neutral)
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
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Desert && currentTile.TacticalType != this.Const.World.TerrainTacticalType.DesertHills)
		{
			return;
		}

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.World.Assets.getMoney() < 150)
		{
			return;
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

