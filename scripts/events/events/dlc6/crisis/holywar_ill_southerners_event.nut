this.holywar_ill_southerners_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.holywar_ill_southerners";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 70.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_71.png[/img]{Vous croisez une ferme et pensez passer devant, mais tout à coup, la porte s'ouvre et un homme en tombe, les jambes se balançant sur le porche jusqu'à ce qu'il tombe à plat dans le jardin. Dégainant votre épée, vous l'examinez. En le retournant, vous découvrez un visage vert et violet, une bouche recouverte de vomi et de sang séché, et des cheveux tombant de sa tête. Vous laissez le corps et entrez dans la ferme où vous trouvez d'autres hommes comme lui. Ce sont tous des sudistes qui semblent avoir contracté une maladie nordique à laquelle ils ne sont peut-être pas immunisé. À en juger par l'état négligé de leur équipement, ils sont terrés ici depuis un certain temps. L'un des sudistes vous tend une main décrépite. S'il vous plaît, envoyez-nous au doreur. La lumière de ce monde n'est plus.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Terminons-les avec dignité",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Que les mouches festoient sur votre chair décrépite.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_71.png[/img]{Les Sudistes sont tués avec dignité, ou du moins autant de dignité qu'une épée peut le permettre. Bien sûr, vous les tuez longuement, sans oser poser la main sur leurs corps malades. Après les avoir enterrés, vous jetez un coup d'oeil à la propriété. Par chance, et probablement parce que le matériau frottait leurs peaux à vif, les malades avaient déposé du matériel sur le côté. Vous demandez aux frères de le nettoyer et vous l'emportez avec vous sur la route. En partant, il y a quelques râleurs qui disent que ces hommes méritaient peut-être pire, mais d'autres sont tout à fait d'accord avec les meurtres par pitié.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Il vaut mieux qu'ils ne souffrent pas plus longtemps.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local amount = this.Math.rand(10, 20);
				this.World.Assets.addArmorParts(amount);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_supplies.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + amount + "[/color] Tools and Supplies."
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist")
					{
						continue;
					}

					if (bro.getEthnicity() == 1 && this.Math.rand(1, 100) <= 66)
					{
						bro.improveMood(1.0, "J'approuve votre décision de mettre fin aux souffrances de mes camarades dorés.");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else if (bro.getEthnicity() == 0 && this.Math.rand(1, 100) <= 66)
					{
						bro.worsenMood(0.75, "Je n'ai pas aimé que vous mettiez fin aux souffrances des envahisseurs du Sud");

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
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_71.png[/img]{Une partie de l'équipement des sudistes a été enlevée et placée dans la pièce. Vous demandez aux mercenaires de les prendre et de les nettoyer. Vous vous rendez à la porte d'entrée, allumez une torche et dites-leur que le doreur les verra bientôt sous son vrai jour. Les soldats implorent la pitié, une masse de silhouettes se tordant en rampant vers vous, gémissant de faiblesse et de peur. Vous fermez la porte et mettez le feu au toit avant de lancer la torche à travers une fenêtre. Vous avez bien appris à vos hommes à ne pas prendre personnellement ce genre de décisions, mais vous pensez que certains membres du %companyname% pourraient ne pas apprécier celle-ci.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ils n'ont pas à envahir le nord.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-1);
				local amount = this.Math.rand(10, 20);
				this.World.Assets.addArmorParts(amount);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_supplies.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + amount + "[/color] Tools and Supplies."
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist")
					{
						continue;
					}

					if (bro.getEthnicity() == 1 && this.Math.rand(1, 100) <= 66)
					{
						bro.worsenMood(1.0, "Je n'ai pas aimé que vous laissiez le camarade Gilded souffrir d'une mort lente.");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else if (bro.getEthnicity() == 0 && this.Math.rand(1, 100) <= 66)
					{
						bro.improveMood(0.75, "Approuvé votre décision de laisser mourir les envahisseurs du Sud.");

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

		if (!this.World.FactionManager.isHolyWar())
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type == this.Const.World.TerrainType.Desert || currentTile.Type == this.Const.World.TerrainType.Steppe || currentTile.TacticalType == this.Const.World.TerrainTacticalType.DesertHills)
		{
			return;
		}

		if (currentTile.SquareCoords.Y < this.World.getMapSize().Y * 0.2)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local closest = 9000;

		foreach( t in towns )
		{
			local d = t.getTile().getDistanceTo(currentTile);

			if (d < closest)
			{
				closest = d;
			}
		}

		if (closest < 7 || closest > 20)
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

