this.runaway_harem_event <- this.inherit("scripts/events/event", {
	m = {
		Citystate = null
	},
	function create()
	{
		this.m.ID = "event.runaway_harem";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 200.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_170.png[/img]{Vous tombez sur un groupe clairsemé de nomades qui se disputent avec une troupe d'hommes du Vizir. Entre eux se trouve un autre groupe de ce qui semble être le genre de femmes qui feraient partie du harem du Vizir. Lorsque vous vous approchez, toutes les parties s'arrêtent et vous fixent. Un lieutenant de la troupe du Vizir vous fait signe de vous éloigner. %SPEECH_ON% Cela ne vous concerne pas, mercenaire. %SPEECH_OFF%Mais, essayant peut-être de vous inviter à l'événement, les nomades expliquent : les femmes sont des endettées, celles dont le service est dû à un autre pour des échecs ou des transgressions. Dans ce cas, elles doivent des services au Vizir. Mais elles se sont échappées et les nomades, pour qui le concept de dette est une hérésie, les ont recueillies.%SPEECH_ON%Hey, mercenaire ! N'écoute pas un mot de ce nomade ! Et nomade, ces femmes viennent avec nous, ou vous mourrez tous ici.%SPEECH_OFF%}",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Je préfère ne pas être impliqué dans cette affaire.",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "Les femmes appartiennent au Vizir.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Les femmes sont libres d'aller où elles veulent.",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.Citystate.getUIBannerSmall();
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_170.png[/img]{Vous dégainez votre épée et dites aux hommes du Vizir d'aller se faire voir, en espérant que cela fonctionne car toute violence avec eux ne se fera pas sans une bonne dose de sang versé. Heureusement, ils battent en retraite. Le lieutenant s'incline d'un air moqueur.%SPEECH_ON%Les femmes sont libres, mais leurs dettes envers le Doreur n'ayant pas été payées, elles brûleront dans des fosses de sable brûlant, un enfer dont on ne pourra jamais s'échapper!%SPEECH_OFF%En riant, vous le remerciez pour les images. Les nomades vous remercient également, ainsi que le harem libéré, bien que ce soit plus avec leurs yeux qu'autre chose. Un nomade te tend un cadeau contenant des trésors. %SPEECH_ON% Nous portons ces objets non pas pour nous, mais pour le cas où nous rencontrerions des voyageurs comme toi. Nous ne cherchons pas de réconfort dans les choses matérielles, pas dans ce monde. Et ne faites pas confiance à cet homme du Vizir. Il ment. Le Doreur nous verra tous dans la sublimité quand notre heure sera venue.%SPEECH_OFF%}",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Profitez de votre liberté.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.Citystate.getUIBannerSmall();
				this.World.Assets.addMoralReputation(1);
				this.World.Assets.addMoney(100);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]100[/color] Couronnes"
					}
				];
				_event.m.Citystate.addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Vous avez aidé à la fuite du harem d'un Vizir");
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_170.png[/img]{Vous savez reconnaître un bon jour de paie quand vous en voyez un, et par jour de paie vous voulez dire un ambassadeur d'un Vizir. Dégainant votre épée, vous vous interposez entre les nomades et les femmes, ordonnant aux premiers de se retirer et de retourner dans les déserts. Les nomades tirent des arcs et brandissent des lances, mais leur chef les fait taire.%SPEECH_ON%Non, l'intrus est intervenu de la manière qu'il juge la plus appropriée, et le Vizir l'a certainement choisi comme arbitre dans cette affaire pour de bonnes raisons. Prenez les femmes, alors, et le conflit est réglé.%SPEECH_OFF%Les hommes du Vizir rassemblent le harem dans leurs rangs. Le lieutenant vous apporte un lourd sac. Paiement, du roi. Ce n'était pas votre tâche, mais cela ne veut pas dire qu'il n'y a pas de récompense. Vous avez sauvé ces femmes endettées des flammes de l'enfer de la Gildera. Que notre générosité soit un rappel constant à l'avenir, oui ?%SPEECH_OFF%}",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nous nous réjouissons de poursuivre notre collaboration avec votre maître.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.Citystate.getUIBannerSmall();
				this.World.Assets.addMoney(150);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]150[/color] Couronnes"
					}
				];
				_event.m.Citystate.addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Vous avez aidé à rendre le harem d'un Vizir");
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_170.png[/img]{Vous secouez la tête et souhaitez aux femmes ce qu'il y a de mieux, mais l'affaire est résolue avant même que vous puissiez partir : les nomades se retirent et les hommes du Vizir les emmènent. Lorsque vous demandez aux nomades pourquoi ils ont abandonné si vite, leur chef déclare que vous avez dû être un arbitre envoyé par le Doreur lui-même, et si c'est ce que vous avez choisi, alors qu'il en soit ainsi. Il semble que les nomades n'aient jamais eu la moindre chance de battre ces soldats professionnels et que vous étiez leur dernier espoir.}",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C'est dans l'ordre des choses.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.Citystate.getUIBannerSmall();
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

		local towns = this.World.EntityManager.getSettlements();
		local bestTown;
		local bestDistance = 9000;

		foreach( t in towns )
		{
			local d = currentTile.getDistanceTo(t.getTile());

			if (d <= bestDistance)
			{
				bestDistance = d;
				bestTown = t;
			}
		}

		if (bestTown == null || bestDistance < 7)
		{
			return;
		}

		this.m.Citystate = bestTown.getOwner();
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
		this.m.Citystate = null;
	}

});

