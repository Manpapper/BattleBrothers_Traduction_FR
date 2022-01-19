this.civilwar_wounded_soldier_event <- this.inherit("scripts/events/event", {
	m = {
		NobleHouse = null
	},
	function create()
	{
		this.m.ID = "event.crisis.civilwar_wounded_soldier";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 25.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_21.png[/img]{En marchant le long d\'un chemin, vous croisez un soldat de %noblehouse%, vos alliés. Il est au sol, appuyé contre une paroi rocheuse, un bras passé au-dessus de celle-ci comme s\'il venait de poser la dernière pierre. En vous regardant, il ricane.%SPEECH_ON%Qu\'est-ce que tu veux, mercenaire ? Tu viens m\'achever, hein ? Prendre tout ce que j\'ai et plus encore ?%SPEECH_OFF%Il porte une belle armure et a une arme sur lui. Non pas qu\'il puisse se défendre avec dans son état actuel, mais elle aurait l\'air bien entre les mains de l\'un de vos hommes. %randombrother% s\'approche.%SPEECH_ON%Nous pouvons le prendre, monsieur, mais nous devrions faire vite. Qui sait qui pourrait nous attraper car il porte le tabard de l\'armée d\'un noble.%SPEECH_OFF% | Vous tombez sur un soldat blessé de %noblehouse%, vos alliés. Allongé dans l\'herbe, il se redresse pour bien vous voir et vous le regardez bien en retour : l\'homme est orné d\'un ensemble d\'armure décent et il a une arme en équilibre sur ses jambes. Vous pourriez prendre les deux, mais l\'homme ne semble pas disposé à s\'en séparer pacifiquement. Et il y a de fortes chances que le reste de l\'armée du soldat ne soit pas loin... | Un soldat blessé de %noblehouse%, vos alliés, est allongé sur le chemin. Il se traîne, mais en vous entendant il s\'arrête et se retourne.%SPEECH_ON%Ah merde. Tu ferais mieux de faire demi-tour, mercenaire. Mes hommes ne sont pas loin là-bas et si vous me poursuivez, je vais crier.%SPEECH_OFF%Vous lèvez un sourcil.%SPEECH_ON%Vous allez crever en criant comme une femme, hein ?%SPEECH_OFF%L\'homme crache.%SPEECH_ON %Je vais mourrir en sachant que je n\'aurai pas à attendre longtemps pour te revoir dans l\'autre monde.%SPEECH_OFF%Le connard sarcastique a une belle armure et des armes sur lui, mais %randombrother% avertit que c\'est un membre de l\'armée d\'un noble. | Un soldat blessé de l\'armée de %noblehouse%\ se trouve devant vous. D\'une part, il a une arme et une armure que vous pourriez prendre. D\'un autre côté, il fait sans aucun doute partie d\'une force beaucoup, beaucoup plus grande que la vôtre. Il se trouve juste qu\'elle ne vous regarde pas en ce moment même. Si vous décidez de prendre ses affaires, assurez-vous d\'être rapide. | Chance ou catastrophe imminente ? Vous avez trouvé un soldat blessé vêtu d\'une armure plutôt jolie.Il a également une arme à ses côtés qui serait encore plus belle aux côtés d\'un de vos hommes. Prendre ses affaires serait un jeu d\'enfant. Personne n\'est là pour le voir et l\'étouffer ne serait pas si difficile.\n\nPar contre, si quelqu\'un devait le voir, ce serait probablement quelqu\'un faisant partie d\'une très, très grande armée parce que ce soldat porte l\'habit de %noblehouse%, votre allié. Hésitation, décision... | Vous tombez sur un soldat blessé portant une bannière déchiquetée de %noblehouse%, votre allié. En vous voyant, il recule rapidement dans l\'herbe. Il agite sa main et essaie de jurer, mais seul du sang sort de sa bouche. %brother% marche vers vous.%SPEECH_ON%Monsieur, il a une belle armure et une arme sur lui. Nous pourrions l\'éliminer, si vous voulez, mais il y a un risque que son armée ne soit pas loin. Nous devons être très prudents à ce sujet.%SPEECH_OFF% | Vous trouvez un soldat de %noblehouse% essayant de défoncer la porte d\'un taudis abandonné. En vous entendant, il se retourne rapidement, levant une épée pour se défendre. La lame, cependant, vacille dans une prise instable. Le sang coule le long de son bras, dégoulinant au niveau du poignet, et l\'homme a du mal à se tenir debout.%SPEECH_ON%Dégagez, vous tous !%SPEECH_OFF%Un homme craintif acculé dans un coin. Comme il est malheureux qu\'il ne soit pas un animal, de peur que vous n\'y réfléchissiez à deux fois...\n\n %randombrother% vous attrape par le bras.%SPEECH_ON%Attendez, monsieur. Si le reste de son armée nous repère, nous allons avoir de gros problèmes. Essayons de réfléchir, ouais ?%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			Banner = "",
			Options = [
				{
					Text = "Nous ferions mieux de le laisser tranquille et de passer à autre chose.",
					function getResult( _event )
					{
						return 0;
					}

				},
				{
					Text = "Cette armure et cette arme peuvent être utiles, et il n\'en aura pas besoin dans l\'au-delà.",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(-1);

						if (this.Math.rand(1, 100) <= 50)
						{
							return "B";
						}
						else
						{
							return "C";
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
			Text = "[img]gfx/ui/events/event_21.png[/img]{Tu dégaines ton épée et tu t\'approches du soldat. Il crie, mais c\'est bref, se terminant par le claquement aigu de votre lame passant de sa langue à l\'arrière de sa tête. Se gargarisant, il mord le métal du coup fatal avant de s\'affaler. Des yeux frissonnants vous regardent alors qu\'une mort froide le prend. Récupérant votre épée, vous regardez par-dessus votre épaule et dites aux hommes de prendre tout ce qu\'il avait sur lui. Vous essuyez votre lame sur le tissu de la bannière du mort. | L\'homme voit l\'intention dans vos yeux et élève rapidement la voix, mais vous vous précipitez vers l\'avant, dégainant votre lame et la faisant passer dans son cerveau en un mouvement rapide. Il meurt et vous ressentez un pincement au flanc. Pas morale, mais une douleur plus ancienne, plus réelle. %randombrother% vous stabilise avec une main sur votre épaule.%SPEECH_ON%Du calme, monsieur, vous n\'êtes plus aussi souple que vous l\'étiez autrefois.%SPEECH_OFF%Acquiesçant, vous nettoyez votre lame et dites aux hommes de piller ce qu\'ils peuvent. | Le soldat se penche en arrière.%SPEECH_ON%Ah, je vois.%SPEECH_OFF%Il lève le cou.%SPEECH_ON%Tu m\'as eu. Je vais mourrir comme un homme devrait.%SPEECH_OFF%Avec une coupure rapide, il baisse la tête, une mousse cramoisie bouillonnante coule sur sa poitrine. Vos hommes pillent ce qu\'ils peuvent. | Vous sortez votre poignard. L\'homme lève son arme, mais vous l\'écartez. Son bras tombe sans effort, comme si vous veniez de le soulager d\'un énorme fardeau. Il vous fixe.%SPEECH_ON%Attendez...%SPEECH_OFF%C\'est son dernier mot. Il essaie de prononcer autre chose, mais l\'énorme entaille que vous avez ouverte sur sa gorge ne produit que d\'horribles gargarismes. Vous ordonnez à %randombrother% de piller tout ce qu\'il peut du corps.}",
			Image = "",
			Characters = [],
			List = [],
			Banner = "",
			Options = [
				{
					Text = "Une autre victime de la guerre.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.addLoot(this.List);
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_90.png[/img]{Vous sortez votre épée et marchez vers l\'homme. Il lève la main et vous enfoncez la lame dans sa paume et directement dans son cerveau. Sa langue pendante, ses derniers mots, une parole baveuse et sanglante. En nettoyant votre lame, vous vous tournez vers %randombrother%, seulement pour voir des bannerets se tenir à l\'horizon.%SPEECH_ON%Oh putain de merde. Tout le monde court !%SPEECH_OFF% %companyname% fait une retraite rapide, bien que désordonnée, bondissant à travers les bosquets et les lits de ruisseaux et faisant demi-tour, se cachant et tuant silencieusement un chien de chasse avant qu\'il ne puisse aboyer. Vous réussissez à vous en sortir à la fin, mais sans avoir le temps de prendre quoi que ce soit. | Vous sortez votre épée et la plongez dans la poitrine de l\'homme. Il tend la main et vous attrape par votre chemise, se hissant sur la lame. Il porte ses dents dans un sourire sanglant.%SPEECH_ON%Allez-y, mercenaire. Je vous verrai de l\'autre côté.%SPEECH_OFF%Il lâche prise et retombe, un jaillissement rouge éclabousse alors que votre épée le quitte. Soudainement, %randombrother% vous appelle, sa voix aiguë.%SPEECH_ON%Monsieur, nous devrions y aller ! Les bannerets, regardez !%SPEECH_OFF%Debout au sommet d\'une colline voisine se trouvent les cavaliers de %noblehouse% et ils ont sans aucun doute vu ce que vous avez fait. En criant aussi fort que possible, vous ordonnez aux hommes de battre rapidement en retraite. Bien que vous parveniez à vous en sortir, vous avez sans doute perdu la bonne volonté de votre potentiel employeur. | Le soldat rit tandis que vous vous appuyez sur lui. Il rit alors que vous le plantez dans la poitrine avec votre épée. Et il rit, un dernier éclat de rire fatigué, alors que vous récupérez votre lame. Ses yeux s\'estompent en regardant au-delà de vous une colline voisine où, apparemment, la plaisanterie meurtrière se tient : les bannerets du soldat sont à cheval se découpant sur l\'horizon, ayant ostensiblement vu votre acte.\n\nEn criant, vous ordonnez à %companyname%  de battre en retraite de peur qu\'une armée entière ne fonde sur vous et ne vous décime. Dans la fuite précipité, vous renoncez à prendre tout équipement pour votre acte. Un échange raisonnable pour garder la tête sur les épaules, cependant. | D\'un rapide coup d\'épée, vous ouvrez la gorge de l\'homme. Il plaque sa main sur la blessure, mais sa vie lui glisse littéralement entre les doigts. Alors qu\'il tombe, %randombrother% vous crie dessus.%SPEECH_ON%Monsieur, regardez !%SPEECH_OFF%Les camarades bannerets du soldat se tiennent sur une colline éloignée, ayant sans doute vu ce que vous venez de faire. Avec un ordre rapide, vous obtenez de %companyname% un retrait précipité, quittant la zone aussi vite que possible avant qu\'une armée entière ne vous tombe dessus. Dans la retraite frénétique, vous n\'avez pas le temps de prendre un prix pour votre acte sanglant.}",
			Image = "",
			Characters = [],
			List = [],
			Banner = "",
			Options = [
				{
					Text = "Hubris! Satané hubris!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationOffense, " A tué un de leurs hommes");
			}

		});
	}

	function addLoot( _list )
	{
		local item;
		local banner = this.m.NobleHouse.getBanner();
		local r;
		r = this.Math.rand(1, 4);

		if (r == 1)
		{
			item = this.new("scripts/items/weapons/arming_sword");
		}
		else if (r == 2)
		{
			item = this.new("scripts/items/weapons/morning_star");
		}
		else if (r == 3)
		{
			item = this.new("scripts/items/weapons/military_pick");
		}
		else if (r == 4)
		{
			item = this.new("scripts/items/weapons/warbrand");
		}

		this.World.Assets.getStash().add(item);
		_list.push({
			id = 10,
			icon = "ui/items/" + item.getIcon(),
			text = "Vous obtenez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
		});
		r = this.Math.rand(1, 4);

		if (r == 1)
		{
			item = this.new("scripts/items/armor/special/heraldic_armor");
			item.setFaction(banner);
		}
		else if (r == 2)
		{
			item = this.new("scripts/items/helmets/faction_helm");
			item.setVariant(banner);
		}
		else if (r == 3)
		{
			item = this.new("scripts/items/armor/mail_shirt");
		}
		else if (r == 4)
		{
			item = this.new("scripts/items/armor/mail_hauberk");
			item.setVariant(28);
		}

		item.setCondition(44.0);
		this.World.Assets.getStash().add(item);
		_list.push({
			id = 10,
			icon = "ui/items/" + item.getIcon(),
			text = "Vous obtenez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
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

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local nobleHouses = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);
		local candidates = [];

		foreach( h in nobleHouses )
		{
			if (h.isAlliedWithPlayer())
			{
				candidates.push(h);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.NobleHouse = candidates[this.Math.rand(0, candidates.len() - 1)];
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

