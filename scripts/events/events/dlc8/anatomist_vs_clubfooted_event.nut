this.anatomist_vs_clubfooted_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		Clubfooted = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_vs_clubfooted";
		this.m.Title = "Pendant le camps...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Vous trouvez %anatomist% l\'anatomiste en train de regarder %clubfoot% qui est dans une situation compliquée: à savoir que l\'un de ses pieds ressemble à... rien. C\'est une chose dégoûtante et disgracieuse, qui l\'empêche bien sûr d\'accomplir toutes les tâches que l\'on attend d\'un mercenaire. On dit qu\'il est étrangement populaire auprès des femmes, mais ce sont des ouï-dire non confirmés. Quoi qu\'il en soit, l\'anatomiste vient vous voir avec une suggestion.%SPEECH_ON%Ce n\'est pas une maladie rare, ce pied bot. Si il est prit à temps, il est facilement soigné, mais plus on attend, plus l\'opération devient de plus en plus difficile à réaliser. Heureusement, je suis un anatomiste de formation qui possède de grandes connaissances sur ce sujet. Si vous me le permettez, j\'essaierai de guérir cet homme de cette malheureuse et inutile circonstance de toute une vie.%SPEECH_OFF%%clubfoot% lui-même acquiesce, disant qu\'il est prêt à accepter si vous pensez que c\'est le mieux.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Faites-le, exercez votre métier.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				},
				{
					Text = "Non, le risque est trop grand.",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Clubfooted.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Vous donnez le feu vert à %anatomist%. Lui et l\'homme au pied bot partent ensemble. Naturellement, vous allez jeter un coup d\'œil. Vous regardez l\'anatomiste qui pose le pied bot sur un tabouret. Il sort un morceau de bois sur lequel sont déjà gravées des marques de dents. Il sort ensuite une fiole remplie de liquide, fait sauter le bouchon, y trempe le bois, en boit lui-même une gorgée, puis tend le reste à son patient. %clubfoot% boit la mixture puis mord le bois. Ce qui suit est dégoûtant de jambes cassées, de moulages et de re-moulages. %anatomist% commence à découper avec un scalpel, affichant un sourire fou pendant qu\'il travaille. %clubfoot% s\'est évanoui depuis longtemps.\n\nAu bout du compte, la jambe de %clubfoot%% est totalement démolie et plâtrée. L\'anatomiste dit que l\'opération a été un succès, mais qu\'un temps de récupération un peu long sera nécessaire. Il faudra refaire le moulage du pied encore et encore, et à chaque fois déplacer un peu plus le pied, mais c\'est possible. Un %clubfoot% délirant sourit en regardant son pied.%SPEECH_ON%Ça en vaudra la peine, capitaine. Pour moi, et aussi pour la compagnie %companyname%.%SPEECH_OFF%Le mercenaire, plutôt obéissant et drogué, tombe alors à la renverse et s\'endort en ronflant.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Marche, marche, mon frère, c'est ta vie.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Clubfooted.getSkills().removeByID("trait.clubfooted");
				this.List.push({
					id = 10,
					icon = "ui/traits/trait_icon_23.png",
					text = _event.m.Clubfooted.getName() + " is no longer Clubfooted"
				});
				local injury = _event.m.Clubfooted.addInjury([
					{
						ID = "injury.broken_leg",
						Threshold = 0.0,
						Script = "injury/broken_leg_injury"
					}
				]);
				this.List.push({
					id = 11,
					icon = injury.getIcon(),
					text = _event.m.Clubfooted.getName() + " suffers " + injury.getNameOnly()
				});
				injury = _event.m.Clubfooted.addInjury([
					{
						ID = "injury.cut_achilles_tendon",
						Threshold = 0.0,
						Script = "injury/cut_achilles_tendon_injury"
					}
				]);
				this.List.push({
					id = 12,
					icon = injury.getIcon(),
					text = _event.m.Clubfooted.getName() + " suffers " + injury.getNameOnly()
				});
				_event.m.Clubfooted.improveMood(1.0, "Had his clubfoot cured");
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Clubfooted.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]{A contrecœur, vous donnez le feu vert à %anatomiste% l\'anatomiste pour se mettre au travail. Vous envisagez de le rejoindre avec %clubfoot% dans la tente, mais l\'idée de casser un pied pour le guérir ne vous convient pas vraiment. Au lieu de cela, vous vous consacrez à votre tâche préférée: faire l\'inventaire. La paix et la tranquillité de noter combien il vous reste, de combien vous aurez besoin, la vitesse à laquelle la compagnie consomme ces produits. Tout cela est fascinant.\n\nIl n\'y a vraiment rien de tel que de compter les stocks, et la seule chose qui pourrait interrompre votre plaisir, ce sont les cris stridents et horribles de %clubfoot% qui émanent soudainement de la tente dans laquelle vous avez évité d\'entrer. Maintenant que ses cris stridents emplissent l\'air, vous courez vers la tente pour voir. Vous trouvez %anatomist% sur le côté, en train d\'essuyer la sueur de son front.%SPEECH_ON%Bonjour capitaine. Bien, laissez-moi résumer ici. Comme vous pouvez le voir, il y a eu quelques complications imprévues. Il va guérir, bien sûr, ne vous inquiétez pas pour ça, mais le pied bot restera. Il s\'est avéré, euh, résistant à mes traitements.%SPEECH_OFF%Vous regardez %clubfoot%. Il est maintenant évanoui, sa jambe est tordue comme un chiffon. L\'anatomiste acquiesce consciencieusement.%SPEECH_ON%Ne vous inquiétez pas pour ça, je vais arranger ça aussi. J\'avais juste besoin que l\'homme arrête de crier et de bouger autant et d\'un peu d\'air pour que je puisse reprendre mon souffle. Vous voulez regarder?%SPEECH_OFF%L\'anatomiste saisit le pied de l\'homme. Il l\'agite dans sa main comme s\'il tenait de la pâte. Vous secouez la tête et vous vous précipitez hors de la tente.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Aaaaahh.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local injury = _event.m.Clubfooted.addInjury([
					{
						ID = "injury.broken_leg",
						Threshold = 0.0,
						Script = "injury/broken_leg_injury"
					}
				]);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Clubfooted.getName() + " suffers " + injury.getNameOnly()
				});
				injury = _event.m.Clubfooted.addInjury([
					{
						ID = "injury.traumatized",
						Threshold = 0.0,
						Script = "injury_permanent/traumatized_injury"
					}
				]);
				this.List.push({
					id = 11,
					icon = injury.getIcon(),
					text = _event.m.Clubfooted.getName() + " suffers " + injury.getNameOnly()
				});
				_event.m.Clubfooted.worsenMood(this.Const.MoodChange.PermanentInjury, "Experimented on by a madman");
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Clubfooted.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Vous regardez %anatomist% avec curiosité.%SPEECH_ON%Est-ce que je dirige une écurie de chevaux ici? Si cet homme veut que son pied bot soit soigné, il peut aller paître avec honneur et dignité. Nous n\'aurons pas besoin d\'expériences bizarres qui aboutiront à des résultats que seuls les dieux connaissent.%SPEECH_OFF%L\'anatomiste s\'éclaircit la gorge et dit que les procédures sont assez simples, mais il fait une erreur en disant aussi que les gains scientifiques à réaliser sont immenses, ce qui montre qu\'il n\'avait pas du tout en tête de bonnes intentions envers %clubfoot%. Vous dites à l\'homme que la conversation est terminée.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Vous marcherez en boitant à partir de maintenant.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.worsenMood(1.0, "Was denied a research opportunity");

				if (_event.m.Anatomist.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.anatomists")
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomistCandidates = [];
		local clubfootedCandidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomistCandidates.push(bro);
			}
			else if (bro.getBackground().getID() != "background.anatomist" && bro.getSkills().hasSkill("trait.clubfooted"))
			{
				clubfootedCandidates.push(bro);
			}
		}

		if (clubfootedCandidates.len() == 0 || anatomistCandidates.len() == 0)
		{
			return;
		}

		this.m.Clubfooted = clubfootedCandidates[this.Math.rand(0, clubfootedCandidates.len() - 1)];
		this.m.Anatomist = anatomistCandidates[this.Math.rand(0, anatomistCandidates.len() - 1)];
		this.m.Score = 5 * clubfootedCandidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getNameOnly()
		]);
		_vars.push([
			"clubfoot",
			this.m.Clubfooted.getName()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
		this.m.Clubfooted = null;
	}

});

