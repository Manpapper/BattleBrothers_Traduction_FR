this.witchhut_destroyed_event <- this.inherit("scripts/events/event", {
	m = {
		Replies = [],
		Results = [],
		Texts = []
	},
	function create()
	{
		this.m.ID = "event.location.witchhut_destroyed";
		this.m.Title = "After the battle";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Texts.resize(7);
		this.m.Texts[0] = "Qui êtes-vous ?";
		this.m.Texts[1] = "Comment savez-vous qui je suis?";
		this.m.Texts[2] = "Qui étaient les anciens?";
		this.m.Texts[3] = "Qu\'est-ce que Davkul?";
		this.m.Texts[4] = "Les peaux vertes étaient-elles humaines?";
		this.m.Texts[5] = "Pourquoi m\'avez-vous appelé le Faux Roi?";
		this.m.Texts[6] = "De quoi est-ce que je rêve?";
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_115.png[/img]{La dernière des sorcières est tuée et vous faites mutiler leurs cadavres pour faire bonne mesure. Oreilles. Lèvres. Nez. Orteils. Tout est coupé. Leurs sacs sont vidés et les objets réduits en cendres et couverts de poussière. Les morceaux charnus ou les parties d\'animaux sont jetés sur un tas et promptement brûlés. Alors que le feu s\'élève, l\'hexen de la hutte semble sortir de nulle part et vous prend par le bras. Vos hommes tirent leurs épées, mais vous levez la main. Vous leur dites de continuer à saler la terre, pour ainsi dire, et en entrant dans la hutte, vous jetez un coup d\'œil en arrière pour voir quelques hommes pisser sur les braises du feu.\n\n À l\'intérieur de la hutte, vous vous asseyez là où vous étiez avant. Sur la table, vous trouvez quelque chose enroulé dans un mouchoir. La sorcière en pince le bout et le roule entre son doigt et son pouce. Elle lève les yeux, penche le menton vers l\'avant et tourne ses paumes vers le haut.}",
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
			Text = "[img]gfx/ui/events/event_115.png[/img]{La sorcière sourit.%SPEECH_ON%Une vieille sorcière qui vit dans une cabane dans la forêt. Tout le reste n\'est que ouï-dire.%SPEECH_OFF%Vous la fixez assez longtemps pour voir qu\'il y a peu d\'intérêt à poursuivre cette discussion.}",
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
			Text = "[img]gfx/ui/events/event_115.png[/img]{Elle fixe l\'objet emballé.%SPEECH_ON%Je ne connais même pas ton nom, mercenaire, et je n\'ai pas la moindre envie de m\'en soucier. Il ne s\'agit pas de savoir qui vous êtes, mais ce que vous êtes.%SPEECH_OFF%Elle tourne ses mains comme si elles suivaient une mélodie.%SPEECH_ON%Le sang des anciens réside en vous. Il réside en nous tous, mais vous en particulier.%SPEECH_OFF%Son nez se plisse alors qu\'elle renifle, et elle expire en souriant comme une folle.%SPEECH_ON%Il est toujours là. Et si je peux le sentir, alors le monde entier peut le sentir.%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_115.png[/img]{Elle tapote le mouchoir et ce qui se trouve en dessous tape sur la table. Elle répond.%SPEECH_ON%Les anciens étaient des hommes avant notre ère. Vraiment, vraiment avant notre ère. Imaginez un royaume, maintenant imaginez un royaume qui gouverne des royaumes. Un empire, c\'est exact. Maintenant, imaginez un empire qui gouverne les empires. Une puissance insondable telle que celle-ci quitte le monde avec une incroyable vengeance, et passera ses derniers jours à ruiner ceux qui l\'ont ruiné.%SPEECH_OFF%Vous demandez si l\'empire est mort. La sorcière sourit.%SPEECH_ON%Je ne le soupçonne pas, mais je ne le sais pas vraiment.%SPEECH_OFF%}",
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
			ID = "B3",
			Text = "[img]gfx/ui/events/event_115.png[/img]{Haussant les épaules et se penchant en arrière, l\'hexen vous demande de répéter le nom. \'Davkul.\' Elle secoue la tête.%SPEECH_ON%Je n\'ai jamais rien entendue à propos de ce Davkul. Un supposé dieu, dites-vous? Eh bien, il ne m\'a pas parlé.%SPEECH_OFF%Vous la fixez et essayez de découvrir une vérité cachée dans ses yeux, mais elle semble sérieuse dans sa réponse et vous changez de sujet.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.m.Replies[3] = true;
				_event.addReplies(this.Options);
			}

		});
		this.m.Screens.push({
			ID = "B4",
			Text = "[img]gfx/ui/events/event_115.png[/img]{L\'hexen glousse.%SPEECH_ON%J\'aimerais bien! Vous avez vu ce que les orcs ont entre les jambes? Je ne serais pas contre un tour là-dessus si je savais que ça ne me déchirerait pas en deux et ne me baiserait pas d\'un côté en portant l\'autre comme un gant!%SPEECH_OFF%Vous levez un sourcil et hochez la tête comme pour dire \"bien sûr\".}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.m.Replies[4] = true;
				_event.addReplies(this.Options);
			}

		});
		this.m.Screens.push({
			ID = "B5",
			Text = "[img]gfx/ui/events/event_115.png[/img]{Pour la première fois, il y a une faille dans la personnalité de la sorcière. Elle se pince les lèvres.%SPEECH_ON%Quand t\'ai-je appelé comme ça?%SPEECH_OFF%Vous désignez la porte, puis la table. Vous répondez.%SPEECH_ON%Je suis entré ici et vous avez dit que je chercherais la vérité, que vous savez ce dont rêve le faux roi.%SPEECH_OFF%L\'hexen tapote le mouchoir sans réfléchir. Elle lève les yeux.%SPEECH_ON%Alors vous avez mes excuses, mercenaire, je ne me souviens pas d\'une telle chose. Je ne suis qu\'une vieille femme fragile, plus âgée que je n\'en ai l\'air, et je ne suis pas effrontée à ce point.%SPEECH_OFF%Vous la pressez sur le sujet, mais elle ne fait que l\'éviter davantage.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.m.Replies[5] = true;
				_event.addReplies(this.Options);
			}

		});
		this.m.Screens.push({
			ID = "Dream",
			Text = "[img]gfx/ui/events/event_115.png[/img]{L\'hexen se penche en avant. Elle pose ses mains sur votre visage et vous sentez ses doigts rugueux s\'enfoncer dans vos joues comme une demi-douzaine de noix. Ils frottent les angles de vos yeux et tapent sur vos tempes. Pendant tout ce temps, elle sourit, puis elle se retire.%SPEECH_ON%Vous allez chez les nobles et les riches, ils paient en or et en retour vous risquez votre vie et votre intégrité physique, vous massacrez, assassinez et tuez tout ce que vous pouvez, et vous êtes toujours là, jour après jour, à vous demander si vous n\'êtes bon qu\'à ça, et après, les nobles vous ferment la porte au nez, vous les entendez à l\'intérieur en train de s\'amuser, la musique joue, les femmes rient, les bouffons plaisantent, les festivités sont violentes, dehors avec un sac d\'or à la main et son récépissé ensanglanté, vous descendez au pub pour payer une pute puis donnez une pièce au ménestrel pour une chanson, vous pouvez même goûter à un bon vin même dans la cave la moins chère, mais il n\'y a pas d\'échappatoire à cet horrible sentiment dans le fond de votre tête, ce sentiment que vous êtes né dans la fièvre et que toute cette violence et ces mort ne sont pas un moyen de parvenir à vos fin, mais c\'est la fin elle-même. C\'est ce que vous êtes et ce que vous serez toujours.%SPEECH_OFF%Elle fait une pause. Soupire. Continue.%SPEECH_ON%Mercenaire, le pouvoir d\'un mensonge n\'a d\'égal que le désir d\'y croire. Vous vivez un mensonge puissant, et un tel pouvoir ne disparaîtra pas facilement. Je vous en prie, ne faites que ce que vous pouvez comprendre.%SPEECH_OFF%Ce n\'est pas vous, ni votre armement, ni la présence de toute votre compagnie qui lui a fait peur, mais seulement l\'émergence d\'une prise de conscience inconnue au moment où elle vous parle.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Qui suis-je?!",
					function getResult( _event )
					{
						return "WhoAmI";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "WhoAmI",
			Text = "[img]gfx/ui/events/event_115.png[/img]{Vous vous levez en criant sur la femme pour obtenir des réponses. Elle vous gifle au visage, vous vous raidissez et reculez d\'un pas. Une goutte de sang glisse sur votre joue, vous l\'attrapez dans votre manchette. La sorcière saisit le mouchoir et le jette, révélant la lame d\'obsidienne en dessous. Elle est plus nette que dans votre souvenir, un éclat vif de vous-même courant le long du bord, comme si vous aviez fendu une porte vers un miroir. L\'hexen se rassoit et pousse l\'arme sur la table.%SPEECH_ON%Plus de questions, mercenaire. Il y a tellement de choses que je sais, et tellement de choses que vous devez savoir. Nous avons passé un accord et il touche à sa fin.%SPEECH_OFF%Prenant la dague, vous lui demandez ce qu\'elle lui a fait, mais elle refuse de répondre. Vous lui demandez alors s\'il y en a d\'autres comme elle. Elle vous fait un sourire malicieux.%SPEECH_ON%Je prie pour qu\'il n\'y en ait pas.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nous avons terminé, alors, je vais prendre congé.",
					function getResult( _event )
					{
						return "Leave";
					}

				},
				{
					Text = "Vous avez rempli votre objectif, alors. Meurs, sorcière!",
					function getResult( _event )
					{
						return "Kill";
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.getStash().makeEmptySlots(1);
				local item = this.new("scripts/items/weapons/legendary/obsidian_dagger");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Leave",
			Text = "[img]gfx/ui/events/event_115.png[/img]{Vous dites adieu à la sorcière mais elle ne parle plus. Dehors, les hommes demandent ce qu\'elle a dit, tandis que d\'autres font référence à des escapades sexuelles. Vous pensez que vous souriez d\'un air suffisant, mais vous en êtes pas sûr. La conversation vous a laissé dans le brouillard mais vous êtes sûr d\'une chose: il faut remettre l\'entreprise en route.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C\'est l\'heure de partir.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Flags.set("IsWitchhutLeft", true);
			}

		});
		this.m.Screens.push({
			ID = "Kill",
			Text = "[img]gfx/ui/events/event_115.png[/img]{La sorcière croise les doigts et hoche la tête. Vous faites un signe de tête en retour. Elle prend la dague d\'obsidienne et la plonge dans sa poitrine.Elle saigne comme n\'importe quel homme ou femme que vous connaissez. Elle tousse et s\'étouffe avec son sang comme tout être vivant. Elle recule, les yeux écarquillés par la peur, comme beaucoup de personnes que vous avez connues auparavant. Vous sortez la dague et vous la frappez. Elle se met à gémir, ses mains se tendent pour arracher des poignées de capteurs de rêves et des toiles d\'araignée, son coude heurte une planche de couverts en bois, les ustensiles s\'éparpillent dans toute la cabane dans un bruit creux. Ses doigts fragiles enserrent un couteau à beurre, ses yeux vous transpercent. Elle tousse une fois, deux fois. Elle lâche le couteau à beurre pour se frapper la poitrine avec le poing, un filet de sang gicle sur son menton. Elle lève les yeux.%SPEECH_ON%Nous avions un accord, parole de mercenaire. Vous rengainez la dague et hochez la tête.%SPEECH_ON%Oui, vous avez fait un marché avec un mercenaire et vous avez obtenu ce que vous vouliez. Moi?. J\'ai fait un pacte avec le monde pour me débarrasser entièrement de vous et de votre espèce. Bonne continuation et bonne chance.%SPEECH_OFF%En déglutissant, la tête de l\'hexen s\'effondre sur le sol et son corps devient mou. Lorsque vous vous dirigez vers l\'extérieur, la compagnie demande ce qui s\'est passé. Vous leur dites de brûler la cabane et de se préparer à reprendre la route.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C\'est l\'heure de partir.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Flags.set("IsWitchhutKilled", true);
			}

		});
	}

	function addReplies( _to )
	{
		local n = 0;

		for( local i = 0; i < 6; i = ++i )
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
				n = ++n;

				if (n >= 4)
				{
					break;
				}
			}
		}

		if (n == 0)
		{
			_to.push({
				Text = this.m.Texts[6],
				function getResult( _event )
				{
					return "Dream";
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
		this.m.Replies.resize(6, false);
		this.m.Results = [];
		this.m.Results.resize(6, "");

		for( local i = 0; i < 6; i = ++i )
		{
			this.m.Results[i] = "B" + i;
		}
	}

	function onPrepareVariables( _vars )
	{
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
	}

});

