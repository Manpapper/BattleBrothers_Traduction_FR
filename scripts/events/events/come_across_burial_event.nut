this.come_across_burial_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.come_across_burial";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 130.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_28.png[/img]Sur la route, vous croisez une foule de personnes rassemblées autour d\'un monticule de terre. En vous approchant, vous réalisez qu\'il s\'agit d\'un enterrement. L\'un des participants se retourne pour vous regarder.%SPEECH_ON%L\'avez-vous connu ? Avez-vous combattu à ses côtés ?%SPEECH_OFF%Vous secouez la tête et commencez à couper dans la foule pour voir l\'homme lui-même. Vous trouvez un homme qui semble aussi vieux que les morts peuvent l\'être. Il a une épée terriblement tranchante et étincelante qui court le long de sa poitrine, ses doigts sales et véreux agrippant le pommeau. %randombrother% vous rejoint et chuchote.%SPEECH_ON%C\'est, euh, une épée plutôt jolie, je dis ça comme ça.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Faisons en sorte qu\'elle soit nôtre.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 35 ? "B" : "C";
					}

				},
				{
					Text = "Laissons les.",
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
			Text = "[img]gfx/ui/events/event_36.png[/img]Vous sortez votre épée et le reste de la compagnie fait de même. Les mercenaires repoussent la foule, mais il n\'y a pas autant de résistance que vous le pensiez. L\'un des participants s\'avance.%SPEECH_ON%C\'est l\'épée que vous voulez, n\'est-ce pas ? Allez-y, prenez-la. Cet homme mort là-bas a parlé de quelqu\'un comme vous. Il a dit que vous en auriez plus besoin que lui.%SPEECH_OFF%Rengainant votre épée, vous lui demandez si c\'est pour ça qu\'ils étaient tous là. L\'homme rit.%SPEECH_ON%Nah, il a aussi dit qu\'il ne mourrait jamais, donc nous étions curieux de savoir si cette partie de ses paroles se réaliserait.%SPEECH_OFF%Vous prenez lentement l\'épée, curieux de savoir s\'il y a un dicton qui parle de massacrer l\'homme qui pose ses mains dessus. Heureusement, ostensiblement, le puissant homme mort n\'a pas dit une telle chose.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Il n\'en aura plus besoin maintenant.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/weapons/longsword");
				item.setCondition(27.0);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_28.png[/img]Vous traversez la foule et attrapez l\'épée du mort. L\'un des participants s\'écrie. %randombrother% décoche un coup de poing et envoie le paysan voldinguer. Les autres membres de la compagnie sortent leurs armes pour s\'assurer que les protestations n\'aillent pas loin. Une femme âgée se fraye un chemin dans la foule, aussi bien qu\'une femme âgée le peut, en vacillant et en tremblant.%SPEECH_ON%Messire, ce n\'est pas à vous. Remettez-la à sa place.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Elle m\'appartient maintenant",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "La vieille femme a raison, nous ne devrions pas déranger l\'enterrement plus longtemps.",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-1);
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_36.png[/img]Vous dites à la vieille dame de ramper dans un trou et d\'y mourir. L\'épée de l\'homme mort est mise dans votre inventaire et %companyname% reprend la route.\n\nBouleversés, les paysans s\'écrient que la nouvelle de ce que vous avez fait va parcourir les vents comme un coup de tonnerre. Vous riez simplement et appréciez leur imagination.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C\'est comme ça que le monde fonctionne",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-3);
				local item = this.new("scripts/items/weapons/longsword");
				item.setCondition(27.0);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_28.png[/img]Vous remettez l\'épée dans les mains de l\'homme mort. La vieille dame acquiesce.%SPEECH_ON%Il y a donc toujours des hommes de bien qui écouteront encore les personnes les plus sages.%SPEECH_OFF%Un autre paysan salue votre honneur et d\'autres font de même. Il semble que le simple fait de prendre l\'arme et de la remettre en place était suffisant pour justifier une sorte de prestige festif aux yeux des profanes. Peut-être que vous devriez feindre le vol plus souvent.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "On en avait pas besoin de toute façon.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(5);
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.getTime().Days <= 15)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (currentTile.Type == this.Const.World.TerrainType.Snow || currentTile.Type == this.Const.World.TerrainType.Forest || currentTile.Type == this.Const.World.TerrainType.LeaveForest || currentTile.Type == this.Const.World.TerrainType.SnowyForest)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		this.m.Score = 2;
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

