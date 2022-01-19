this.civilwar_trapped_soldiers_event <- this.inherit("scripts/events/event", {
	m = {
		NobleHouse = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.crisis.civilwar_trapped_soldiers";
		this.m.Title = "A %town%";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_43.png[/img]Vous croisez une grande foule de paysans en effervescence. En y regardant de plus près, ils ont encerclé un petit groupe de soldats portant la bannière de %noblehouse%, à qui appartient ce village. Chaque homme a sorti son épée, mais ils se sont retrouvés dans un coin et complètement en infériorité numérique. Les villageois crient et pointent du doigt.%SPEECH_ON%Meurtriers ! Violeurs ! Incendiaires !%SPEECH_OFF%Les crachats et les lancers de tomates suivent le mouvement. %randombrother% vient vers vous et vous demande si les hommes doivent intervenir ou rester en dehors.",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Nous devons mettre un terme à cela.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
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
					Text = "Ce n\'est pas notre combat.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "D";
						}
						else
						{
							return "E";
						}
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
			Text = "[img]gfx/ui/events/event_43.png[/img]Aucun homme, surtout un combattant, ne mérite d\'être lynché. Vous ordonnez à vos hommes d\'intervenir, en aboyant suffisamment fort pour que la moitié de la foule se retourne pour vous voir. Des chuchotements se répercutent dans la foule et vous acquiescez avec confiance.%SPEECH_ON%Écartez-vous, paysans. Ces hommes méritent peut-être beaucoup de choses, mais votre justice indisciplinée n\'en fait pas partie.%SPEECH_OFF%Un paysan débraillé crie.%SPEECH_ON%Mais ce sont des meurtriers et pire !%SPEECH_OFF%Vous lancez un regard sévère.% SPEECH_ON%Et mes hommes aussi. Maintenant, écartez-vous.%SPEECH_OFF%La foule fait ce qu\'on lui dit. Les soldats secourus vous disent que %noblehouse% entendra parler de vos actes ici.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Cela s\'est plutôt bien passé. ",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationFavor, "A Sauvé certains de leurs hommes");
				this.World.Assets.addMoralReputation(1);
				_event.m.Town.getFactionOfType(this.Const.FactionType.Settlement).addPlayerRelation(this.Const.World.Assets.RelationMinorOffense);
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_43.png[/img]Il n\'y a aucune raison pour que les soldats soient lynchés comme ça. Ou, pour une raison quelconque, le pincement soudain de la justice à vos côtés le dit. D\'une voix forte, vous vous annoncez comme un tiers neutre ici pour arbitrer les événements. Les échanges cordiaux ne durent pas plus d\'une seconde avant que les paysans, plus stridents et hystériques que jamais, annoncent que vous n\'êtes que des soldats de %noblehouse%. Vous levez la main pour expliquer, mais une mêlée éclate.\n\n Vous ne pouvez que grimacer en regardant vos hommes abattre les paysans un par un, comme des fermiers puissants fauchant les champs de blé. C\'est un spectacle monstrueux et quelques passants regardent avec horreur avant de s\'enfuir, sûrement pour raconter aux autres ce que vous avez fait ici. Les soldats, à l\'inverse, remercient vos hommes ensanglantés et sanglants.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Je ne sais pas ce que j\'attendais.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "A Sauvé certains de leurs hommes");
				this.World.Assets.addMoralReputation(-2);
				_event.m.Town.getFactionOfType(this.Const.FactionType.Settlement).addPlayerRelation(this.Const.World.Assets.RelationOffense, "A Tué certains de leurs hommes");
				local brothers = this.World.getPlayerRoster().getAll();
				local candidates = [];

				foreach( bro in brothers )
				{
					if (!bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
					{
						candidates.push(bro);
					}
				}

				local numInjured = this.Math.min(candidates.len(), this.Math.rand(1, 3));

				for( local i = 0; i < numInjured; i = ++i )
				{
					local idx = this.Math.rand(0, candidates.len() - 1);
					local bro = candidates[idx];
					candidates.remove(idx);
					local injury = bro.addInjury(this.Const.Injury.Brawl);
					this.List.push({
						id = 10,
						icon = injury.getIcon(),
						text = bro.getName() + " souffre " + injury.getNameOnly()
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_43.png[/img]S\'impliquer pourrait simplement compliquer les choses - les paysans sont inconstants et sans instruction, voyants de leur propre solitude, pourvoyeurs de malchance et de paranoïa. Vous ordonnez à vos hommes de ne pas se contenter de se tenir à l\'écart, mais de se faire petits.\n\n Un jet de pierres ouvre l\'attaque, bientôt suivi d\'un mur de fourches et de machettes. Les soldats essaient de se battre, mais le meilleur résumé de leur défense est celui de cris horribles. L\'un est traîné hors du tas, donnant des coups de pied et criant, et les paysans le poignardent à plusieurs reprises jusqu\'à ce qu\'il s\'arrête. Un autre est encordé et hissé à un arbre, pendu par la force de trois hommes en colère.\n\nFatiguée, la foule se calme. Les enfants dansent autour des pieds du mort. Un pauvre homme marmonnant sautille autour des cadavres, fouillant dans les poches de chacun.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "La friction de la guerre lorsqu\'elle rencontre la folie du profane.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				this.World.Assets.addMoralReputation(-1);
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_43.png[/img]Vous décidez de vous tenir à l\'écart. Ce n\'est pas votre combat et vous impliquer ne fera que compliquer les choses. En vous reculant, vous regardez la foule se jeter sur les soldats. Il y a une bagarre, des voix stridentes par-dessus le vacarme du chaos, des cris agités de ceux qui ne sont pas préparés à un moment final aussi brutal. Mais un soldat se fraye un chemin à travers la foule, faisant tomber les gens de ses jambes et poignardant un homme dans les yeux. Il parvient à sprinter vers un cheval à proximité, à monter et à le pousser dans un galop. L\'homme regarde la bannière de %companyname%\ en passant. Vous ne pouvez pas vous empêcher de penser que %noblehouse% pourrait entendre parler de votre neutralité ce jour-là...",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Je suis sûr qu\'il ne dira rien.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Refus d'aider leurs hommes");
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

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local playerTile = this.World.State.getPlayer().getTile();
		local towns = this.World.EntityManager.getSettlements();
		local bestDistance = 9000;
		local bestTown;

		foreach( t in towns )
		{
			if (t.isMilitary() || t.isSouthern() || t.getSize() > 2)
			{
				continue;
			}

			local d = playerTile.getDistanceTo(t.getTile());

			if (d < bestDistance)
			{
				bestDistance = d;
				bestTown = t;
			}
		}

		if (bestTown == null || bestDistance > 3)
		{
			return;
		}

		this.m.NobleHouse = bestTown.getOwner();
		this.m.Town = bestTown;
		this.m.Score = 25;
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
		_vars.push([
			"town",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.NobleHouse = null;
		this.m.Town = null;
	}

});

