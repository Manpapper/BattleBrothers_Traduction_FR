this.drunk_nobleman_event <- this.inherit("scripts/events/event", {
	m = {
		Other = null,
		Servant = null,
		Thief = null,
		Townname = null
	},
	function create()
	{
		this.m.ID = "event.drunk_nobleman";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 80.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{Alors que vous êtes en route, vous tombez sur un noble ivre qui titube d\'un côté à l\'autre du chemin. Mussy est le nom de ses cheveux, des feuilles, de l\'herbe et ce qui ressemble à de la merde d\'oiseau s\'y trouve, comme si quelqu\'un avait mélangé les ingrédients et fait une farce. Mais ses vêtements sont faits de la plus belle des soies et ses doigts brillent de bijoux. Il a une bouteille dans chaque main et les balance en chantant des chants de tavernes, un vrai charabia.\n\nIl est, à tous égards, le plus grand aimant à agressions que vous ayez jamais vu. %randombrother% pince ses lèvres et ressemble à un loup qui dévisage un gros mouton.%SPEECH_ON%Je ne dis rien, monsieur, je... Je le vois, c\'est tout. C\'est beaucoup de jus. Beaucoup de jus sur la route. Mais encore une fois, je ne dis rien.%SPEECH_OFF%Vous savez de quoi il parle.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nous allons le voler.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Servant != null)
				{
					this.Options.push({
						Text = "Pourquoi regarde-t-il %servant%?",
						function getResult( _event )
						{
							return "G";
						}

					});
				}

				if (_event.m.Thief != null)
				{
					this.Options.push({
						Text = "Peut-être que %thief% peut alléger son fardeau.",
						function getResult( _event )
						{
							return "H";
						}

					});
				}

				this.Options.push({
					Text = "Laissez-le tranquille.",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "%terrainImage%{Vous vous approchez de l\'homme et l\'aidez à s\'asseoir. Il sourit lorsqu\'une de ses bouteilles s\'écrase sur le chemin et roule au loin.%SPEECH_ON%Meeerciii, m\'sieur, ouais, hein?, je sais pas... *Hips*.%SPEECH_OFF%En hochant la tête, vous lui tendez la main et crachez sur ses doigts, puis vous enlevez le bijou et le mettez dans votre poche. Il se contente de regarder comme si vous étiez un médecin traitant une maladie. Le reste de vos mercenaires le dépouille et lui jette une bâche en peau de chèvre dessus, puis le laisse là. En partant, il vous demande si vous connaissez ce breuvage.%SPEECH_ON%Je ne veux pas dévoiler le secret, mais, messieurs, les breuvages sont bons.%SPEECH_OFF%Oui, ils sont toujours là. Malheureusement, alors que vous rejoignez la compagnie, %randombrother% rapporte qu\'un enfant a tout vu et s\'est enfui. Vous lui demandez pourquoi il ne lui a pas couru après. Il vous regarde d\'un air malin.%SPEECH_ON%Je ne suis pas du genre à détaler, monsieur.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Repose-toi bien, étranger.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-1);
				local f = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);
				f = f[this.Math.rand(0, f.len() - 1)];
				f.addPlayerRelation(-15.0, "Rumored to have robbed a family member on the road");
				this.List.push({
					id = 10,
					icon = "ui/icons/special.png",
					text = "Your relation to " + f.getName() + " has suffered"
				});
				local money = this.Math.rand(1, 100);
				this.World.Assets.addMoney(money);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Couronnes"
				});
				local item = this.new("scripts/items/loot/signet_ring_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/loot/valuable_furs_item");
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
			Text = "%terrainImage%{Vous vous approchez de l\'homme et, surpris, il recule en hoquetant.%SPEECH_ON%Oy, qui êtes-vous?%SPEECH_OFF%En lui disant que vous êtes un bon ami, vous vous approchez pour le dépouiller de tous ses biens, mais lorsque vous faites un pas de plus, ses yeux s\'éclaircissent, il laisse tomber les deux bouteilles et fouille soudainement dans son manteau pour en sortir une arbalète.%SPEECH_ON%Pas un pas de plus, espèce de voyou. J\'ai des hommes là-bas qui surveillent. Je ne veux pas d\'ennuis. On n\'a pas envie de s\'embrouiller avec des mercenaires. On est là pour voler des voyageurs, et pas des bons en plus, on choisit de voler un ivrogne, hein? Maintenant pourquoi ne pas continuer la route et nous laisser tranquille?%SPEECH_OFF%L\'arbalète grince et commence à trembler dangereusement.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Marché conclu.",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "Même pas en rêve.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "E" : "F";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "%terrainImage%{You nod.%SPEECH_ON%Très bien. Je suppose que tout ce que vous avez est contrefait, n\'est-ce pas?%SPEECH_OFF%L\'homme acquiesce.%SPEECH_ON%Bien sûr. C\'est la meilleure contrefaçon de cette partie de %townname%! Mais assez de manigances. J\'apprécie que vous gardiez cette zone, mais on a du travail.%SPEECH_OFF%En hochant la tête une nouvelle fois, vous lui souhaitez bonne chance pour ce qu\'il fait.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Reprenons la route.",
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
			Text = "%terrainImage%{Vous regardez la compagnie, puis vous vous retourner en faisant mine de ranger votre épée. Vous levez votre épée vers le haut puis chargez l\'arbalète, l\'homme tire juste au-dessus de votre épaule. Vous enfoncez la lame dans le bois, coupez les cordes de l\'arme et plantez l\'acier dans la poitrine de l\'homme. Il tombe facilement, on entend des hommes crier au loin mais prennent peur et s\'enfuient. Les voleurs comme lui savent qu\'il ne faut pas se battre avec des mercenaires. Vous récupérez les biens que l\'homme avait volés auparavant.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Voyons ce qu\'il avait.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local money = this.Math.rand(1, 100);
				this.World.Assets.addMoney(money);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Couronnes"
				});
				local item = this.new("scripts/items/loot/signet_ring_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/loot/valuable_furs_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "%terrainImage%{Vous regardez la compagnie, puis vous vous retourner en faisant mine de ranger votre épée. Vous levez votre épée vers le haut puis chargez l\\'arbalète, l\\'homme tire juste au-dessus de votre épaule. Vous enfoncez la lame dans le bois, coupez les cordes de l\\'arme et plantez l\\'acier dans la poitrine de l\\'homme. Il tombe facilement, on entend des hommes crier au loin mais prennent peur et s\\'enfuient. Les voleurs comme lui savent qu\\'il ne faut pas se battre avec des mercenaires. Malheureusement, le carreau d\'arbalète qui est passé par-dessus votre épaule a touché %hurtbro%. Il survivra, mais c\'est une vilaine blessure.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Voyons ce qu\'il avait.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Other.getImagePath());
				local injury = _event.m.Other.addInjury(this.Const.Injury.PiercingBody);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Other.getName() + " souffre de " + injury.getNameOnly()
				});
				local item = this.new("scripts/items/loot/signet_ring_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/loot/valuable_furs_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "%terrainImage%{Lorsque vous vous approchez du noble, ses yeux s\'écarquillent et il désigne %servant% le serviteur.%SPEECH_ON%Attendez une seconde, je vous connais.%SPEECH_OFF%Vous vous retournez. Est-ce vrai? Le noble trébuche en avant, ses jambes se balançant d\'un côté à l\'autre.%SPEECH_ON%Vous serviez mon cousin dans %randomtown% un soir. Vous étiez formidable ! Le plus grand. Le plus génial. S-serviteur. Hargh. Eh bien -hic- j\'ose dire que vous pouvez avoir toute cette merde parce que je ne pense pas -hic- qu\'on vous ait expliqué, désolé, qu\'on vous ait payé.%SPEECH_OFF%L\'homme prend tout ce qui a de la valeur et le jette devant lui. Il semble heureux de s\'être simplement débarrassé de ce poids.%SPEECH_ON%Si vous revoyez mon cousin, dites-lui que j\'ai tué son frère, avec le manteau de cheminée. Sans rancune.%SPEECH_OFF%Bon, d\'accord.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C\'était une bonne chose de faire ce truc il y a quelques temps.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Servant.getImagePath());
				_event.m.Servant.getBaseProperties().Bravery += 2;
				_event.m.Servant.getSkills().update();
				_event.m.Servant.improveMood(1.0, "Finally got paid for a job while back");
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Servant.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+2[/color] Resolve"
				});
				local item = this.new("scripts/items/loot/signet_ring_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "H",
			Text = "%terrainImage%{Alors que vous vous approchez de l\'ivrogne, un sifflement aigu se fait entendre sur le chemin. Vous et l\'ivrogne regardez tous deux pour voir %thief% le voleur, il se tient là avec une arme dans le dos appartenant à quelqu\'un d\'autre.%SPEECH_ON%Ce type n\'est pas un noble, et probablement pas un ivrogne non plus. Ils travaillent ensemble pour piéger les voyageurs ou les menacer de chantage. Ce sont des voleurs, monsieur.%SPEECH_OFF%Vous vous retournez pour voir l\'homme qui sourit nerveusement. Il s\'explique de manière fluide.%SPEECH_ON%Nous n\'avions aucun intérêt à voler des mercenaires, monsieur, je-je-je jure que j\'étais sur le point de m\'expliquer dès que j\'ai vu vos épées.%SPEECH_OFF%%thief% crie, demandant où est la cachette. Vous vous retournez vers l\'homme et lui dites de vous remettre tout ce qu\'il a volé. Il acquiesce et vous demande si il va se faire étriper s\'il refuse. Vous acquiescez et lui dites que l\'éviscération viendra en dernier, et qu\'à ce moment-là, ce sera un soulagement. L\'homme met un peu d\'entrain dans sa démarche.%SPEECH_ON%Oui, j\'ai compris monsieur, par ici.%SPEECH_OFF%} ",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Le voleur a flairé le coup.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Thief.getImagePath());
				local money = this.Math.rand(1, 100);
				this.World.Assets.addMoney(money);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Couronnes"
				});
				local item;
				item = this.new("scripts/items/loot/signet_ring_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/loot/silverware_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen)
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

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_servant = [];
		local candidates_thief = [];
		local candidates_other = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.servant" || bro.getBackground().getID() == "background.juggler")
			{
				candidates_servant.push(bro);
			}
			else if (bro.getBackground().getID() == "background.thief")
			{
				candidates_thief.push(bro);
			}
			else
			{
				candidates_other.push(bro);
			}
		}

		if (candidates_other.len() == 0)
		{
			return;
		}

		this.m.Other = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];

		if (candidates_servant.len() != 0)
		{
			this.m.Servant = candidates_servant[this.Math.rand(0, candidates_servant.len() - 1)];
		}

		if (candidates_thief.len() != 0)
		{
			this.m.Thief = candidates_thief[this.Math.rand(0, candidates_thief.len() - 1)];
		}

		this.m.Score = 10;
	}

	function onPrepare()
	{
		local towns = this.World.EntityManager.getSettlements();
		local playerTile = this.World.State.getPlayer().getTile();
		local nearest_town_distance = 999999;
		local nearest_town;

		foreach( t in towns )
		{
			local d = t.getTile().getDistanceTo(playerTile);

			if (d < nearest_town_distance)
			{
				nearest_town_distance = d;
				nearest_town = t;
			}
		}

		this.m.Townname = nearest_town.getName();
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"hurtbro",
			this.m.Other.getNameOnly()
		]);
		_vars.push([
			"servant",
			this.m.Servant ? this.m.Servant.getNameOnly() : ""
		]);
		_vars.push([
			"thief",
			this.m.Thief ? this.m.Thief.getNameOnly() : ""
		]);
		_vars.push([
			"townname",
			this.m.Townname
		]);
	}

	function onClear()
	{
		this.m.Other = null;
		this.m.Servant = null;
		this.m.Thief = null;
		this.m.Townname;
	}

});

