this.holywar_sand_storm_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.holywar_sand_storm";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 70.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_161.png[/img]{Vous tombez sur une troupe d'hommes à moitié enterrés dans le sable. Des Nordistes pris dans une tempête de sable pendant la nuit. Ils se tordent de douleur, du moins ceux qui sont en vie. Certains ont eu la chair arrachée à l'os, d'autres sont déjà dévorés par les scorpions et les buses. Il semble que certains se soient suicidés. Aucune de ces âmes ne peut être sauvée, elles s'accrochent juste à la fin.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Tuez-les avec dignité.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Laissez-les aux sables.",
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
			Text = "[img]gfx/ui/events/event_161.png[/img]{Dégainant votre épée, vous demandez aux hommes s'ils acceptent la dignité d'une mort rapide par votre acier. Ils sont trop assoiffés et affamés pour parler, mais quelques-uns hochent la tête. L'un d'eux meurt avant même d'avoir pu répondre. Vous allez vers chacun d'eux, vous vous accroupissez, leur souhaitez bonne chance, et enfoncez l'épée. La peau craque sous la lame, et les hommes mourants sont brièvement revivifiés par la douleur perçante, puis ils quittent ce monde. Quelques-uns des membres de la compagnie ont des opinions différentes à ce sujet. Vous demandez à l'épée de ramasser ce qu'elle peut, bien que la plupart des équipements aient été détruits par la furie du désert.}",
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

					if (bro.getEthnicity() == 0 && this.Math.rand(1, 100) <= 66)
					{
						bro.improveMood(1.0, "Approuvé votre décision de mettre fin aux souffrances de vos compatriotes du Nord.");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else if (bro.getEthnicity() == 1 && this.Math.rand(1, 100) <= 66)
					{
						bro.worsenMood(0.75, "Je n'ai pas aimé que vous mettiez fin aux souffrances des envahisseurs du Nord");

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
			Text = "[img]gfx/ui/events/event_161.png[/img]{Vous ordonnez aux mercenaires de dépouiller les hommes mourants de tout équipement utile. Les croisés ne peuvent que marmonner et gémir lorsqu'ils sont dépouillés de leurs armes et armures. Leurs corps nus sont abandonnés aux sables brûlants, et tandis que vous partez avec les restes d'équipement utile, les animaux du désert commencent déjà à s'installer et à se nourrir. Des sentiments mitigés traversent %companyname% à propos de cette décision, mais en fin de compte les contestations ou le soutien restent silencieux.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Le Doreur les a jugés.",
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

					if (bro.getEthnicity() == 0 && this.Math.rand(1, 100) <= 66)
					{
						bro.worsenMood(1.0, "Je n'ai pas aimé que vous laissiez vos compatriotes du Nord souffrir d'une mort lente");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else if (bro.getEthnicity() == 1 && this.Math.rand(1, 100) <= 66)
					{
						bro.improveMood(0.75, "Approuvé votre décision de laisser les envahisseurs du Nord jugés par le Doreur");

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

		if (currentTile.Type != this.Const.World.TerrainType.Desert)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(currentTile) <= 7)
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

