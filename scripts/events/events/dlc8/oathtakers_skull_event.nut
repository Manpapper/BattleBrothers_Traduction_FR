this.oathtakers_skull_event <- this.inherit("scripts/events/event", {
	m = {
		Oathtaker = null
	},

	function create()
	{
		this.m.ID = "event.oathtakers_skull";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "{[img]gfx/ui/events/event_183.png[/img]{Vous trouvez %oathtaker% en train de regarder attentivement les orbites du crâne du Jeune Anselme reposant sur sa paume tendue. Il hoche la tête de temps en temps et se murmure à lui-même une sorte de prière. Sentant votre présence, l\'Oathtaker se retourne.%SPEECH_ON%J\'étais inquiet, mais malgré les mers du chaos, nous avons ici le Jeune Anselme, et il est d\'un courage tel que je nagerais dans l\'océan du monde avec une telle assurance qu\'il m\'en sortirait. Je devrais diffuser les enseignements du Jeune Anselme auprès des autres.%SPEECH_OFF%Absolument, il doit le faire.| Les Oathtakers dégustent un bon repas au coin du feu. %oathtaker% tient le crâne du jeune Anselme sur une souche. Il se retourne de temps en temps, une cuillère remplie de cartilage à la main et semble penser à en donner à la gueule osseuse. Ces instants vous mettent mal à l\'aise, mais pour une raison inconnue, le petit crâne a tendance à mettre les Oathtakers de meilleure humeur par sa seule présence, si bien que vous laissez passer ces bizarreries à la fois féminines et macabres. | %oathtaker% regarde un texte avec des couvertures en feutre et un signet doré. À côté de lui, le crâne du jeune Anselme repose près d\'une bougie mourante. Vous demandez à l\'Oathtaker ce qu\'il est en train de lire. L\'homme lève les yeux.%SPEECH_ON%Je consulte certains sujet à propos des Serments, le Jeune Anselme les avait écrites. Souvenez-vous de ses sages paroles: l\'encre est le plus fort des souvenirs, il est donc sage de ne pas dépendre uniquement de ses propres capacités à suivre les Serments, mais plutôt de les noter afin de ne pas les oublier. Cela aussi faisait partie de l\'enseignement du Jeune Anselme. Vous le sauriez si vous vous penchiez sur les textes comme il vous le conseillait.%SPEECH_OFF%Un peu brusque, mais il n\'a pas tort. | Vous voyez %oathtaker% nettoyer le crâne du jeune Anselme. Désireux de tester la foi de l\'homme, vous lui demandez quelque chose que vous savez déjà: comment Anselme est-il mort ? L\'Oathtaker se redresse et vous regarde d\'un air profondément offensé.%SPEECH_ON%Capitaine, peu importe comment il est mort, que ce soit où,comment ou pourquoi ne change rien. Ce qui compte c\'est qu\'il était sur le Serment de la Voie Finale. Nous sommes aussi avec lui et ce jusqu\'à la fin. Nous ne sommes pas seulement des Oathtakers, mais les Oathtakers Finaux.%SPEECH_OFF%Il se retourne, enlève un insecte de l\'os, puis nettoie le crâne comme s\'il avait été profané par les pas de la bestiole.%SPEECH_ON%C\'est une grande expérience que nous entreprenons ici, capitaine, mais parfois je pense que vous êtes juste là pour le plaisir.%SPEECH_OFF%Pour le moins, c\'est une expérience qui permet de vous remplir les poches. Heureusement, la seule personne qui semble capable de remarquer votre nature cynique est un crâne, les orbites du jeune Anselm vous fixant d\'un regard vide tandis que le Oathtaker lui crache dessus. | %oathtaker% s\'agenouille devant le crâne du jeune Anselme.%SPEECH_ON%Donnez-moi la force de nos serments, Jeune Anselme, car je ne peux pas le faire seul et certainement pas avec la seule aide du capitaine.%SPEECH_OFF%Vous êtes sur le point de lui dire qu\'il n\'est pas seul, qu\'il est avec la compagnie %companyname% et que vous n\'êtes pas non plus une mauviette, mais vous vous dites que ce n\'est probablement pas l\'endroit pour ce genre de confrontation. L\'homme se lève soudainement et fait un signe de tête.%SPEECH_ON%De tels conseils sont très appréciés, Jeune Anselme.%SPEECH_OFF%Une partie de vous souhaiterait pouvoir regarder le crâne d\'un jeune garçon pour trouver des conseils, mais la seule chose que vous retirez du visage osseux du jeune Anselme est un regard vide. | L\'entreprise a connu des hauts et des bas, mais le jeune Anselme est toujours considéré comme son principal pourvoyeur de piété. Vous devez admettre que parfois, vous vous surprenez à fixer le crâne avec un soupçon de mépris. Même si vous dirigez le groupe, et que vous le faites assez bien, une grande partie des succès de la compagnie est attribuée au crâne. Lorsque les hommes ont besoin d\'aide, ils s\'adressent souvent au crâne, sans se soucier de leur capitaine. %oathtaker% en est le digne représentant. Il a eu des moments difficiles ces derniers temps, mais au lieu de vous parler, vous le trouvez en train de ramasser le jeune Anselm pour trouver des réponses. Vous rêvez parfois de prendre le crâne et de l\'utiliser pour faire des ricochets sur un lac. | Le crâne du jeune Anselme est une pierre angulaire pour les plus fidèles des Oathtakers, une source de connaissances et de conseils et bien plus encore, le tout jaillissant d\'un réceptacle osseux et silencieux. %oathtaker%, qui se sentait plutôt déprimé ces derniers jours, a eu accès au crâne. Sa foi dans les Serments a été renouvelée, même pendant ce bref entretien. | Vous placez le crâne du jeune Anselme sur un bâton et commencez à le faire tourner, les os s\'entrechoquent, claquent, le tout dans un fracas terriblement amusant. %oathtaker% sort des buissons en demandant quelque chose. Vous en profitez pour reprendre le crâne et le poser.L\'Oathtaker vous regarde, le bâton, le crâne, puis revient vers vous. Il s\'éclaircit la gorge et vous explique qu\'il n\'a pas eu la vie facile ces derniers jours. Pour le guider, et par paresse, vous lui tendez le crâne du Jeune Anselme, lui disant de trouver dans le Premier Oathtaker des réponses, un renouvellement de ses croyances ainsi qu\'une résurgence de son courage. L\'homme acquiesce consciencieusement.%SPEECH_ON%Le Jeune Anselme est peut-être le Premier Oathtaker, mais je crois toujours que vous êtes le plus sage de tous, capitaine. J\'aurais dû m\'occuper d\'Anselm dès le début!%SPEECH_OFF% | Le crâne du jeune Anselme est posé sur une souche, vous essayez de lancer des cailloux dans les orbites. L\'un d\'eux arrive à destination, vous lancez votre poing en l\'air en guise de victoire. Juste à ce moment-là, %oathtaker% arrive. Il vous regarde, vous, votre poing et le jeune Anselme. L\'Oathtaker acquiesce.%SPEECH_ON%Si le Jeune Anselme peut donner du courage à un cynique comme vous, alors les capacités du Premier Oathtaker vont sûrement au-delà de ce que je croyais. Je vais vous laisser seul afin que vous puissiez trouver d\'autres conseils auprès du Jeune Anselme.%SPEECH_OFF%Vous remerciez l\'Oathtaker en hochant la tête. Après son départ, vous vous remettez à votre sport favoris. Malheureusement, vous n\'arrivez même pas toucher la crâne du Jeune Anselme. Il semble que vous ayez perdu votre doigté. | Avec un gros bâton, vous vous amusez à lancer des pierres en l\'air pour les faire retomber en sifflant. Alors que vous vous penchez pour ramasser une autre pierre, vous voyez le crâne du Jeune Anselme qui vous regarde fixement. Naturellement, vous le prenez, le pesant d\'une main. Il est si léger. Vous le lancez en l\'air pour le frapper avec le bâton, des fragments de crâne s\'échappant en spirale dans toutes les directions, la poudre d\'os fine poudrant l\'air autour de vous comme si vous aviez fait un tour de magie. Soudain, vous sentez quelque chose sur votre flanc, le monde dans lequel vous êtes s\'éloigne de plus en plus... Vous vous réveillez pour voir %oathtaker% vous mettre des petits coups de pied. En clignant des yeux, vous réalisez que vous vous êtes assoupi près du feu de camp. Le Oathtaker pose un crâne à côté de vous et hoche la tête.%SPEECH_ON%J\'ai cherché conseil auprès du Jeune Anselme et j\'ai trouvé, capitaine, mais voyant que vous transpiriez dans votre sommeil, j\'ai pensé que vous aimeriez peut-être aussi un moment avec le Premier Oathtaker.%SPEECH_OFF%L\'homme se retourne et s\'en va. Vous restez seul avec le crâne. Il vous fixe d\'un air complice. Un peu trop ouvertement peut-être. Vous tournez la tête pour regarder ailleurs, puis vous vous rendormez. | %oathtaker% n\'a pas eu la vie facile ces derniers jours. Vous lui apportez le crâne du Jeune Anselme et lui dites de s\'asseoir et de réfléchir aux Serments. L\'homme acquiesce, et quelques minutes plus tard, il vient vers vous, le crâne à la main.%SPEECH_ON%Vous aviez raison, capitaine. Je m\'étais éloigné du chemin, mais grâce aux conseils du Premier Oathtaker, je l\'ai retrouvé.%SPEECH_OFF% | Le crâne du jeune Anselm commence à être un peu abîmé. Des morceaux d\'herbe, de boue et quelques insectes le parsèment. %oathtaker% arrive et pose une question stupide à propos du stock. Vous lui coupez la parole, lui tendez le crâne et lui dites de le nettoyer. Il acquiesce, fixant le crâne comme s\'il s\'agissait d\'une livre d\'or pur. Il termine le travail en dix minutes et quand il revient, il est comme neuf, admettant lui-même que le temps passé seul avec le jeune Anselme l\'a revigoré. Cela lui a rappelé pourquoi il s\'était engagé dans les Oathtakers en premier lieu. C\'est bien beau tout ça, mais il a également oublié de vous parler des stocks, ce qui est fantastique.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ce qui vous rend heureux.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Oathtaker.improveMood(1.35, "Young Anselm renewed his faith in the oaths");

				if (_event.m.Oathtaker.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Oathtaker.getMoodState()],
						text = _event.m.Oathtaker.getName() + this.Const.MoodStateEvent[_event.m.Oathtaker.getMoodState()]
					});
				}

				this.Characters.push(_event.m.Oathtaker.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.paladins")
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];
		local haveSkull = false;

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.paladin" && bro.getMoodState() < this.Const.MoodState.Neutral)
			{
				candidates.push(bro);
			}

			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

			if (item != null && (item.getID() == "accessory.oathtaker_skull_01" || item.getID() == "accessory.oathtaker_skull_02"))
			{
				haveSkull = true;
			}
		}

		if (!haveSkull)
		{
			local stash = this.World.Assets.getStash().getItems();

			foreach( item in stash )
			{
				if (item != null && (item.getID() == "accessory.oathtaker_skull_01" || item.getID() == "accessory.oathtaker_skull_02"))
				{
					haveSkull = true;
					break;
				}
			}
		}

		if (!haveSkull)
		{
			return;
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Oathtaker = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 5 * candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"oathtaker",
			this.m.Oathtaker.getName()
		]);
	}

	function onClear()
	{
		this.m.Oathtaker = null;
	}

});

