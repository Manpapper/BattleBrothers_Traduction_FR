this.kraken_cult_enter_event <- this.inherit("scripts/events/event", {
	m = {
		Replies = [],
		Results = [],
		Texts = [],
		Hides = 0,
		Dust = 0,
		IsPaid = false
	},
	function create()
	{
		this.m.ID = "event.location.kraken_cult_enter";
		this.m.Title = "En approchant...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Texts.resize(4);
		this.m.Texts[0] = "Et qui êtes-vous?";
		this.m.Texts[1] = "Alors, que savez-vous?";
		this.m.Texts[2] = "Vous êtes un vrai cinglé.";
		this.m.Texts[3] = "Alors, comment puis-je aider?";
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_120.png[/img]{Vous tombez sur une femme dans les marais, seule, avec un sac à dos et une sacoche contenant des rouleaux de ce qui pourrait être des cartes, il y a une dague à sa hanche gauche et des casseroles à sa droite. Il y a un feu de camp allumé à proximité et une pile de tomes rangés dans une chaussette de velours. Tout ce qu\'elle est et tout ce qu\'elle a est recouvert par la végétation du bourbier. Elle est là à vous fixer et réciproquement. Ce n\'est pas vraiment ordinaire pour une femme d\'être seule dans la tourbière. Elle sourit d\'un air bizarre et hésitant.%SPEECH_ON%Bonjour.%SPEECH_OFF%Une main sur la poignée de votre épée, vous observez les environs craignant une embuscade. Vous lui demandez ce qu\'elle fait par ici et elle dit que vous ne la croiriez pas. Vous en avez vu assez pour ne pas croire que cette femme est folle. La femme acquiesce.%SPEECH_ON%Bon, d\'accord. Venez et je vous montrerai.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Jetons un coup d\'oeil.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Ça va aller, merci.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Flags.set("IsKrakenCultVisited", true);
				this.World.Flags.set("KrakenCultStage", 0);

				if (this.World.State.getLastLocation() != null)
				{
					this.World.State.getLastLocation().setVisited(false);
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_120.png[/img]{Vous dites à la compagnie de rester vigilante quant aux crapules qui se cachent dans le marécage, mais ils se contentent de rire et de dire que vous auriez dû vous arrêter au bordel si vous étiez si remonté et dans un état second. Vous les ignorez et allez vers la femme. Vous la trouvez sur un rondin, en train de tordre avec ses mains un chapeau en forme de champignon, elle parle plutôt ouvertement.%SPEECH_ON%Je suis à la recherche d\'un monstre et qu\'il soit réel ou fictif, pour moi c\'est tout de même un monstre. Vous comprenez?%SPEECH_OFF%Dans un sens, oui. Tous les monstres ne sont pas réels, et une tourbière comme celle-ci pourrait être folle. Vous lui demandez ce qu\'est cette supposée bête. Elle mange un champignon, puis attrape un livre et vous le lance. Une feuille faisant office de marque-page vous indique où regarder. On y voit ce qui ressemble à une pieuvre avec des membres de la taille d\'un navire. Il se bat contre une flotte entière et semble même gagner. La femme se penche en avant, ses mains vertes et molles pendent comme du kudzu entre ses genoux.%SPEECH_ON%Le monstre que je cherche est le kraken.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.addReplies(this.Options);
			}

		});
		this.m.Screens.push({
			ID = "B0",
			Text = "[img]gfx/ui/events/event_120.png[/img]{La femme se penche en arrière. Elle mange un autre champignon et se retourne pour planter sa dague dans un insecte qui se déplaçait sur une bûche. Sans même une pause, elle le mange par la pointe et parle en écrasant sa carapace.%SPEECH_ON%D\'habitude, je serais à court de détails et j\'agiterais déjà cette dague sur votre queue, mais je pense que vous avez envie d\'aider. Je peux le voir dans vos yeux. Vous êtes un tueur, un assassin, une pute, un amateur de pièces de monnaie, et un putain de fou.%SPEECH_OFF%Elle avale les restes de l\'insecte et les recrachent comme les coquilles d\'une graine de tournesol. Elle acquiesce.%SPEECH_ON%Je suis la fille d\'un riche noble, mais cette vie est loin maintenant.%SPEECH_OFF%C\'est le cas.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.m.Replies[0] = true;
				_event.addReplies(this.Options);
			}

		});
		this.m.Screens.push({
			ID = "B1",
			Text = "[img]gfx/ui/events/event_120.png[/img]{Elle se tourne vers ses tomes et les fixe comme s\'ils étaient des pierres tombales.%SPEECH_ON%Mon père possède l\'une des plus grandes bibliothèques de tout le pays. Dans ces salles, j\'ai découvert les histoires de ces marais. Des histoires d\'auteurs qui, sans le savoir, se répétaient. Il y a dix ans. Cent ans. Mille ans. Toujours la même histoire. Une histoire d\'hommes qui arrivent et d\'hommes qui disparaissent. La réponse n\'est pas claire et les réponses sont ambiguës. Des bandits. Des maladies. Un érudit a simplement dit que les hommes ont été tellement émerveillés par les beautés du marais qu\'ils ont décidé d\'y rester. Vous y croyez? Les beautés du marais?%SPEECH_OFF%En souriant, vous dites que vous en regardez un. Elle rit.%SPEECH_ON%Je ne me suis pas vu depuis des mois, mais je suis sérieuse, étranger. J\'ai cherché dans le coin et je n\'ai rien trouvé.%SPEECH_OFF%Elle désigne ses livres.%SPEECH_ON%Vingt disparitions au début, jusqu\'à trois cents hommes de nos jours, en armure, avec des chevaux, certains avec des caravanes, d\'autres avec des nobles protégés, et pourtant je regarde autour de moi et je ne vois pas la moindre chose.%SPEECH_OFF%Si demain, vous mourriez dans les marais, vous savez que personne n\'en aurait rien à foutre de vous non plus, mais autant de récits, c\'est un peu suspect.}}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.m.Replies[1] = true;
				_event.addReplies(this.Options);
			}

		});
		this.m.Screens.push({
			ID = "B2",
			Text = "[img]gfx/ui/events/event_120.png[/img]{Elle hausse les épaules.%SPEECH_ON%Peut-être, mais au moins je n\'ai pas engagé une compagnie pleine de trous du cul.%SPEECH_OFF%Vous regardez en arrière vers la compagnie %companyname% qui, d\'un côté, des mercenaires se battent à coups de poing, un autre glisse un serpent des marais dans le pantalon d\'un mercenaire endormi et, de l\'autre côté, quelques uns vous montrent du doigt, agrippent leur entrejambe et se trémoussent. Vous vous retournez et lui dites qu\'ils ne sont pas si mauvais. Au même moment, un mercenaire hurle à travers le marais.%SPEECH_ON%Raconte-lui la fois où tout le monde est mort et où on t\'a nommé capitaine parce qu\'il n\'y avait personne d\'autre! Les femmes aiment les héros!%SPEECH_OFF%En souriant, vous vous répétez.%SPEECH_ON%Honnêtement, c\'est pas les pires.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.m.Replies[2] = true;
				_event.addReplies(this.Options);
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_120.png[/img]{La femme fouille dans son sac à dos et en sort une chevalière comme vous n\'en avez jamais vu. Elle vous la tend comme si c\'était une fausse pièce de monnaie.%SPEECH_ON%Il y en a plein d\'autres ailleurs. Mais pas ici exactement. Je ne voudrais pas que tu te fasses des idées sur le vol, tu sais. Mais tu fais ce que je demande et je te balance un coffre de ces trucs.%SPEECH_OFF%Vous empochez la bague et vous lui demandez ce dont elle a besoin. Elle répond.%SPEECH_ON%Je n\'en suis pas encore tout à fait sûr. Les marins disent que les krakens sont des ennemis naturels des baleines, mais il n\'y a pas de baleines par ici, puisque nous sommes sur la terre ferme. Mais il y a quelque chose qui s\'en rapproche. Un monstre des marais. Je soupçonne que les krakens, à travers les millénaires, se sont déplacés vers l\'intérieur des terres et se sont nourris de ce qu\'ils pouvaient et, comme lorsqu\'ils étaient dans les mers, ont trouvé des proies. Apportez-moi des %hides% de monstres et je pourrai peut-être sortir la bête de son hibernation.%SPEECH_OFF%Sortir de son sommeil? Où diable pourrait-il dormir? Vous haussez les épaules et vous vous dites que si elle est prête à se débarrasser de ces magnifiques bijoux, vous serez plus qu\'heureux de lui rendre service.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Je vais vous apporter les peaux.",
					function getResult( _event )
					{
						this.World.Flags.set("KrakenCultStage", 1);
						return 0;
					}

				}
			],
			function start( _event )
			{
				if (this.World.State.getLastLocation() != null)
				{
					this.World.State.getLastLocation().setVisited(false);
				}

				if (!_event.m.IsPaid)
				{
					_event.m.IsPaid = true;
					local item = this.new("scripts/items/loot/signet_ring_item");
					this.World.Assets.getStash().add(item);
					this.List.push({
						id = 10,
						icon = "ui/items/" + item.getIcon(),
						text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_120.png[/img]{Vous apportez à la femme les peaux de monstres pour constater qu\'il y a plus de monde maintenant. Quelques hommes et femmes qui se promènent, fouillant dans le marais, mangeant des champignons. Ils demandent si vous êtes ici pour aider à trouver le kraken. Vous leur demandez violemment s\'ils sont là pour être payés aussi parce que vous êtes sûr de ne pas partager les bénéfices. Une femme vous appelle et court vers vous. Elle tourne la tête et enlève la boue de ses cheveux comme si c\'était un chiffon sale.%SPEECH_ON%Ce sont les, ce sont les!%SPEECH_OFF%Elle claque des doigts et quelques assistants emportent les peaux. Vous demandez qui sont ces gens. Elle hausse les épaules.%SPEECH_ON%Ils ont juste commencé à arriver, je suppose. Ils ont dit que c\'était grâces aux étoiles qu\'ils étaient là, je ne vais les contredire. Et non, je ne vais pas leur payer ce que je vous devais. Ils sont juste heureux d\'être ici, loin de tout le reste, loin de tout, toujours.%SPEECH_OFF%Vous levez un sourcil.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "L\'affaire est donc conclue?",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				local items = this.World.Assets.getStash().getItems();
				local num = 0;

				foreach( i, item in items )
				{
					if (item == null)
					{
						continue;
					}

					if (item.getID() == "misc.unhold_hide")
					{
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = "Vous perdez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
						});
						items[i] = null;
						num = ++num;

						if (num >= _event.m.Hides)
						{
							break;
						}
					}
				}

				_event.m.IsPaid = false;
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_120.png[/img]{Une fois les peaux livrées, vous demandez ce qui vous est dû. Elle vous fait un autre signe de la main comme si vous étiez un mendiant et vous fait signe de vous diriger vers ses livres. En vous approchant, vous voyez les assistants qui découpent les peaux des monstres. Ils semblent les tailler en cape. La femme parle.%SPEECH_ON%Je pense que nous sommes proches de l\'éveil. Les assistants ici ont dit qu\'ils ont vu des étoiles, mais je pense que ce qu\'ils ont vraiment vu, ce sont des lucioles. J\'en vois parfois moi-même. Des petites bestioles qui brillent dans le noir. J\'ai essayé d\'en capturer quelques-unes, mais elles continuent à clignoter.%SPEECH_OFF%Bien. Vous demandez votre paiement. Encore une fois. Elle répond en rouvrant ce vieux tome et en regardant le dessin des marins attaqués par le kraken.%SPEECH_ON%Avec autant d\'aide, j\'ai eu plus de temps pour me plonger dans les livres, et j\'ai remarqué quelque chose. Que voyez-vous dans cette image ? Regardez attentivement maintenant.%SPEECH_OFF%Vous le fixez, mais vous haussez les épaules. Elle fait glisser son doigt sur les particularités du dessin, comme si sa narration le gravait à cet instant précis.%SPEECH_ON%Un clair de lune. Cette bataille a eu lieu la nuit. Qu\'est-ce que c\'est que ça, volant au-dessus du combat ? Des mouettes ? Non. Ce sont des chauves-souris. Qu\'est-ce que des chauves-souris peuvent bien faire à voleter au milieu de l\'océan ? Et puis il y a cet homme, à la barre du navire, avec des longues oreilles et une cape noire. Une personnage intéressante, non? Et puis il y a ceci, quelques pages plus bas, un rapport sur, je cite, \"un vagabond qui jetait des chauves-souris hors de sa cape pour masquer sa fuite\". Plutôt particulier, non? Je crois qu\'on les appelait les Nécrosavants. Des Anciens. Et je pense qu\'ils n\'ont pas été pris en embuscade par le kraken. Je pense qu\'ils le chassaient.%SPEECH_OFF%En soupirant, vous lui demandez ce dont elle a besoin. La femme referme le livre en claquant des doigts.%SPEECH_ON%Cela dépend s\'ils existent ou non, car de mes propres yeux je n\'en ai pas été témoin, mais de mon temps j\'ai vu les chamans et les magiciens avec leurs étranges cendres scintillantes. Peut-être une supercherie, peut-être pas. Apportez-moi des %remains% de cendres de ces hommes de la nuit et nous aurons peut-être notre kraken.%SPEECH_OFF%La femme s\'empiffre de champignons avec entrain. Elle fait une pause, souriant avec des calottes noires à la place des dents.%SPEECH_ON%Et puis vous aurez vos couronnes, aussi, bien sûr.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "De la poussière à la recherche de la poussière.",
					function getResult( _event )
					{
						this.World.Flags.set("KrakenCultStage", 2);
						return 0;
					}

				}
			],
			function start( _event )
			{
				if (this.World.State.getLastLocation() != null)
				{
					this.World.State.getLastLocation().setVisited(false);
				}

				if (!_event.m.IsPaid)
				{
					_event.m.IsPaid = true;
					local item = this.new("scripts/items/loot/signet_ring_item");
					this.World.Assets.getStash().add(item);
					this.List.push({
						id = 10,
						icon = "ui/items/" + item.getIcon(),
						text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_120.png[/img]{Avec tout le temps que vous y avez passé, vous pensiez que cet endroit était de plus en plus familier, mais le marais vous semble soudain étrange et étranger, comme si vous entriez dans une vieille chambre pour vous rendre compte que quelque chose a été déplacé.\n\nVous trouvez la femme debout à une certaine distance, avec tout ces assistants juste derrière. Ils portent tous des manteaux faits de peaux de monstres. Ils sont accroupis devant des sphères de lumière verte, les tenant dans leurs mains, vous pouvez voir des rictus dans chaque éclat viridien, des lèvres remplies de rides sifflant doucement une santé mentale déclinante. Les livres, tomes et papiers de la femme sont éparpillés un peu partout. Un brouillard persiste, et il a apporté avec lui une horrible puanteur. Vous demandez où est votre argent. La femme sourit, ses yeux ont la jaunisse, ses lèvres sont desséchées et éclatées, des morceaux de champignons sont éparpillés sur ses joues.%SPEECH_ON%Le mercenaire veut ses couronnes! Il n\'y a rien d\'autre à faire que de partir d\'ici! Il faut fuir!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Qu\'est-ce qui se passe ici ?",
					function getResult( _event )
					{
						return "G";
					}

				},
				{
					Text = "J\'exige d'être payé tout de suite.",
					function getResult( _event )
					{
						return "G";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_103.png[/img]{Vous regardez l\'un des assistants s\'élever soudainement dans les airs, et dans la lumière verte vous voyez le tentacule gluant l\'entraîner vers l\'arrière, il semble que la terre elle-même s\'ouvre. Un millier de branches et de rameaux humides se tordent et dégoulinent, des rangées et des rangées de crocs se dressent, s\'entrechoquent comme s\'ils cherchaient à s\'emparer d\'une part de gâteau. L\'assistant est projeté dans la gueule, les gencives se tordent, il est déshabillé, dépouillé, ébranché et détruit. La femme croque un autre champignon, puis ses mains caressent des bulbes verts, et on peut voir les tentacules qui se glissent sous chacun d\'eux.%SPEECH_ON%Rejoignez-nous, mercenaire! Laissez la Bête des Bêtes festoyer!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "En formation!",
					function getResult( _event )
					{
						this.World.State.getLastLocation().setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID());
						this.World.Events.showCombatDialog(true, true, true);
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
	}

	function addReplies( _to )
	{
		local n = 0;

		for( local i = 0; i < 3; i = ++i )
		{
			if (!this.m.Replies[i])
			{
				local result = this.m.Results[i];
				_to.push({
					Text = this.m.Texts[i],
					function getResult( _event )
					{
						return result;
					}

				});
			}
		}

		if (n == 0)
		{
			_to.push({
				Text = this.m.Texts[3],
				function getResult( _event )
				{
					return "C";
				}

			});
		}
	}

	function onUpdateScore()
	{
	}

	function onPrepare()
	{
		this.m.Replies = [];
		this.m.Replies.resize(3, false);
		this.m.Results = [];
		this.m.Results.resize(3, "");

		for( local i = 0; i < 3; i = ++i )
		{
			this.m.Results[i] = "B" + i;
		}

		if (this.m.Hides == 0)
		{
			local stash = this.World.Assets.getStash().getItems();
			local hides = 0;

			foreach( item in stash )
			{
				if (item != null && item.getID() == "misc.unhold_hide")
				{
					hides = ++hides;
				}
			}

			this.m.Hides = hides + 3;
		}
		else if (this.m.Dust == 0)
		{
			local stash = this.World.Assets.getStash().getItems();
			local dust = 0;

			foreach( item in stash )
			{
				if (item != null && item.getID() == "misc.vampire_dust")
				{
					dust = ++dust;
				}
			}

			this.m.Dust = dust + 3;
		}
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"hides",
			this.m.Hides
		]);
		_vars.push([
			"remains",
			this.m.Dust
		]);
	}

	function onDetermineStartScreen()
	{
		if (!this.World.Flags.get("IsKrakenCultVisited"))
		{
			return "A";
		}
		else if (this.World.Flags.get("KrakenCultStage") == 0)
		{
			return "B";
		}
		else if (this.World.Flags.get("KrakenCultStage") == 1)
		{
			local stash = this.World.Assets.getStash().getItems();
			local hides = 0;

			foreach( item in stash )
			{
				if (item != null && item.getID() == "misc.unhold_hide")
				{
					hides = ++hides;
				}
			}

			if (hides >= this.m.Hides)
			{
				return "D";
			}
			else
			{
				return "C";
			}
		}
		else if (this.World.Flags.get("KrakenCultStage") == 2)
		{
			local stash = this.World.Assets.getStash().getItems();
			local dust = 0;

			foreach( item in stash )
			{
				if (item != null && item.getID() == "misc.vampire_dust")
				{
					dust = ++dust;
				}
			}

			if (dust >= this.m.Dust)
			{
				return "F";
			}
			else
			{
				return "E";
			}
		}
	}

	function onClear()
	{
	}

	function onSerialize( _out )
	{
		this.event.onSerialize(_out);
		_out.writeU8(this.m.Hides);
		_out.writeU8(this.m.Dust);
		_out.writeBool(this.m.IsPaid);
	}

	function onDeserialize( _in )
	{
		this.event.onDeserialize(_in);

		if (_in.getMetaData().getVersion() >= 43)
		{
			this.m.Hides = _in.readU8();
			this.m.Dust = _in.readU8();
			this.m.IsPaid = _in.readBool();
		}
	}

});

