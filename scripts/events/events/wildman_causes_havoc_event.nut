this.wildman_causes_havoc_event <- this.inherit("scripts/events/event", {
	m = {
		Wildman = null,
		Town = null,
		Compensation = 600
	},
	function create()
	{
		this.m.ID = "event.wildman_causes_havoc";
		this.m.Title = "À %townname%";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%townImage%La civilisation n\'est pas un endroit pour un sauvage comme %wildman% et il le prouve rapidement.\n\nApparemment, l\'homme a perdu la tête dans un magasin et a tout saccagé. L\'histoire raconte qu\'il est entré et a commencé à prendre des objets, ne comprenant pas vraiment les normes sociales de paiement des marchandises. Le propriétaire du magasin l\'a alors poursuivi avec un balai, essayant de chasser l\'homme de son magasin. Croyant que le balai était un monstre, l\'homme sauvage est devenu complètement fou. À en juger par les rapports, c\'était une sacrée agitation, allant jusqu\'à des jets de merde. Maintenant, le propriétaire du magasin vous demande une compensation pour les dommages causés. Apparemment, il veut une compensation de %compensation% couronnes. Derrière lui, quelques miliciens de la ville se tiennent debout avec des yeux très attentifs.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ce n\'est pas notre problème.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Bien, la compagnie couvrira les dommages.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Bien, la compagnie couvrira les dommages - mais %wildman% s\'en acquittera.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Wildman.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "%townImage%Vous repoussez le commerçant en lui disant que vous ne lui devez rien. Lorsqu\'il saute à nouveau en avant, votre main se déplace habilement vers le pommeau de votre épée, arrêtant l\'homme d\'un geste rapide. Il lève les mains en l\'air et recule d\'un signe de tête. Quelques habitants de la ville voient cela et passent à côté, essayant d\'éviter votre regard. Les miliciens le remarquent, mais ils ne semblent pas savoir s\'ils doivent agir ou non.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Au diable votre magasin.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "E" : 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Wildman.getImagePath());
				this.World.FactionManager.getFaction(_event.m.Town.getFactions()[0]).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "You refused to pay for damages caused by one of your men");
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_01.png[/img]Vous allez voir la boutique. Le sauvageon a vraiment saccagé sur cet endroit. Et ça pue son... odeur. Ce serait une mauvaise image pour la compagnie de ne pas traiter ce problème avec grand soin. Vous acceptez de payer les dégâts, ce que la plupart des groupes de mercenaires n\'auraient pas fait. Cet acte de bonté n\'échappe pas aux habitants de la ville.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "La charité par la destruction ?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Wildman.getImagePath());
				this.World.Assets.addMoney(-_event.m.Compensation);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous dépensez [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.Compensation + "[/color] Couronnes"
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "%townImage%Constatant les dégâts, vous acceptez de dédommager l\'homme d\'affaires. Mais ce n\'est pas votre faute, c\'est celle du sauvageon. Vous réduisez son salaire : pendant un certain temps, les revenus du mercenaire seront réduits de moitié. De plus, vous prenez les gains qu\'il a faits et les remettez au propriétaire du magasin. Ça ne couvre même pas les dommages, mais c\'est un début. Un homme est heureux, un autre est mécontent.\n\n Vous dites au crétin sauvage que maintenant il réfléchira à deux fois avant d\'étaler de la merde sur les murs de quelqu\'un d\'autre. Mais le sauvageon ne semble pas te comprendre. Il comprend juste que l\'or qu\'il possédait a été donné à quelqu\'un d\'autre, et il regarde son départ avec tristesse et une colère contenue.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ne me regarde pas comme ça, tu sais ce que tu as fait.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(-_event.m.Compensation);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous dépensez [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.Compensation + "[/color] Couronnes"
				});
				this.Characters.push(_event.m.Wildman.getImagePath());
				_event.m.Wildman.getBaseProperties().DailyWage -= this.Math.floor(_event.m.Wildman.getDailyCost() / 4);
				_event.m.Wildman.getSkills().update();
				this.World.FactionManager.getFaction(_event.m.Town.getFactions()[0]).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "One of your men caused havoc in town");
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_daily_money.png",
					text = _event.m.Wildman.getName() + " est maintenant payé [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.Wildman.getDailyCost() + "[/color] Couronnes par jour"
				});
				_event.m.Wildman.worsenMood(2.0, "A eu une réduction de salaire");

				if (_event.m.Wildman.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Wildman.getMoodState()],
						text = _event.m.Wildman.getName() + this.Const.MoodStateEvent[_event.m.Wildman.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_141.png[/img]En quittant la ville, vous entendez un aboiement par-dessus votre épaule. Mais il ne s\'agit pas d\'un chien : vous vous retournez pour trouver un certain nombre de miliciens qui convergent sur la route, sortant en éventail des maisons et des magasins. Ils disent que vous avez fait du tort à cet homme d\'affaires et qu\'ils ne voudront plus de votre espèce dans un endroit comme celui-ci. Vous pouvez payer tout de suite, ou ils vous le prendront de force.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C\'est dommage qu\'il faille en arriver là.",
					function getResult( _event )
					{
						this.World.FactionManager.getFaction(_event.m.Town.getFactions()[0]).addPlayerRelation(this.Const.World.Assets.RelationBetrayal, "Vous avez tué des membres de la milice");
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.CivilianTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.Militia, this.Math.rand(90, 130), this.Const.Faction.Enemy);
						this.World.State.startScriptedCombat(properties, false, false, true);
						return 0;
					}

				},
				{
					Text = "Bien. Je ne me suis pas réveillé ce matin avec l\'intention de massacrer des innocents.",
					function getResult( _event )
					{
						return "G";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Wildman.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_141.png[/img]Les hommes devant vous sont faibles et fragiles, une force bricolée à partir des plus humbles et des plus opprimés. Nulle part dans leurs rangs ne se trouve l\'homme du métier avec lesquels vous avez eu des problèmes. Bien que vous admiriez leur ténacité, vous ne pouvez pas vous résoudre à massacrer la moitié d\'une ville pour une petite affaire. Vous tendez la main de votre côté, suscitant quelques halètements de la part de la foule d\'hommes mal armés, pour qu\'elle vous rende votre main avec une bourse dans sa paume. Un accord est conclu et la compensation est versée. Les habitants de la ville sont soulagés, bien que quelques hommes ne soient pas très heureux de reculer devant un combat.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C\'est mieux comme ça.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Wildman.getImagePath());
				this.World.Assets.addMoney(-_event.m.Compensation);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous dépensez [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.Compensation + "[/color] Couronnes"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().isCombatBackground() && this.Math.rand(1, 100) <= 33)
					{
						bro.worsenMood(1.0, "La compagnie a renoncé à se battre.");
					}

					if (bro.getMoodState() < this.Const.MoodState.Neutral)
					{
						this.List.push({
							id = 10,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.Assets.getMoney() < this.m.Compensation)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern() || t.isMilitary())
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_wildman = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.wildman")
			{
				candidates_wildman.push(bro);
			}
		}

		if (candidates_wildman.len() == 0)
		{
			return;
		}

		this.m.Wildman = candidates_wildman[this.Math.rand(0, candidates_wildman.len() - 1)];
		this.m.Town = town;
		this.m.Score = candidates_wildman.len() * 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"wildman",
			this.m.Wildman.getNameOnly()
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
		_vars.push([
			"compensation",
			this.m.Compensation
		]);
	}

	function onClear()
	{
		this.m.Wildman = null;
		this.m.Town = null;
	}

});

