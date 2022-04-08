this.anatomist_bummed_at_mutations_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_bummed_at_mutations";
		this.m.Title = "En campant...";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "{[img]gfx/ui/events/event_05.png[/img]{%anatomist% est assit près du feu de camp. Presque trop près. Vous le tirer pour qu\'il ne se brule pas. Il lève les yeux, son visage parcemé de pustules et recouvert de celles qui ont déjà éclatée.%SPEECH_ON%Je commence à me demander si je n\'ai pas fais une grosse erreur en buvant cette potion.%SPEECH_OFF%Il se ramène vers les flammes, et il y a un regard dans ces yeux qui rugit qu\'il veut s\'y jeter. Vous ne pouvez pas faire grand chose pour lui, surtout parce qu\'il a l\'air terriblement hideux en ce moment et vous ne préférez pas le toucher. | Vous trouvez %anatomist% qui est adossé au chariot de la compagnie avec une manche retroussée et il se gratte avec un doigt des marques étranges. Curieux, vous lui demandez si ce sont des marques de naissances. L\'anatomiste se retourne, et secoue la tête. Il lève sa chemise pour montrer que ces marques s\'étalent sur tout son corps, tachetant la chair avec des couleurs hideuses qui semblent dures au toucher, comme des croutes qui ne peuvent pas être retirées.%SPEECH_ON%C\'est la potion que j\'ai bu qui a fait ça et je ne sais pas quoi faire de moi-même.%SPEECH_OFF%Vous hochez la tête et lui dites que cela va surement s\'arranger. Il soupire et remet simplement sa chemise en détournant le regard. | %anatomist% se tient au dessus d\'un sceau d\'eau, il y regarde sa reflexion assombrie. Il soupire. Vous lui demandez ce qu\'il est en train de faire, et il se retourne en révélant des rougeurs et des furoncles terrifiants sur sa peau.%SPEECH_ON%Je ne vais pas trop bien, pour être honnête. La concoction que j\'ai ingurgitée semble avoir un effet probablement mortel sur moi, mais je suis peut-être un peu lourd avec mon vocabulaire. Je survivrais, mais cela m\'a blessé plus que dans ma peau et dans mon corps, dans mon esprit. Je me pensais loin de tels sujets, mais maintenant, en voyant mon horrible visage...Je suis dans un état constant d\'inquiétude.%SPEECH_OFF%Vous attrapez son épaule et la serrez, puis vous lui tapottez le dos et faites quelques recommendations comme boire de l\'eau et bien sûr de ne pas s\'en vouloir. Vous n\'avez jamais été bon pour consoler vos hommes, encore moins ceux avec des maladies provenants d\'une folie scientifique. | %anatomist% est abattu. La potion qu\'il a concoctée, et qu\'il était si pressé de boire, la conduit à ce que son corps soit accablé par des maladies diverses allant des rougeurs aux furoncles jusqu\'à ce qui semble être des spasmes inhabituels et beaucoup de morve au nez. Vous lui assurez qu\'il ira mieux, mais cette terrifiante apparence laisse des traces sur l\'anatomiste. | Les étranges concoctions que %anatomist% l\'anatomiste a faite, sont aussi celles qu\'il a bu. Sans surprise, les effets n\'ont pas été bons: rougeurs, infections, mauvaises odeurs, perte de cheveux, et bien d'autres. Bien qu\'en apparence il déclare que ce qu\'il a fait était au nom de la science, vous pouvez dire que toutes ces maladies et défigurations sont mauvaises pour le morale de l\'homme. Vous pouvez seulement esperez que cela s\'améliorera avec le temps. | Des questions de science, qui sont bien loin de votre comprehension, semblent toujours venir avec des risques. Vous vous rappelez votre enfance, quand votre ami a prit le risque des se balancer au bout d'une corde dans une rivière, et par conséquent c'est comme cela que vous avez tous appris le poids que peut supporter une branche dans les affres du chute d'eau.\n\nMaintenant, il semble que %anatomist% l\'anatomiste soit en train de découvrir la nature handicapante des potions extravagantes qu'il boit. Il est recouvert par des rougeurs et des infections, et pour certaines raisons, il est devenu une sirène pour les fourmis, pour qui sait quelle raison adore maintenant ramper sur lui à toutes heures, jours et nuits. Avec un peu d\'espoir, et du temps, ces maladies s'en iront, et avec un peu de chance, prendront ces satanées fourmis avec elles. | Vous avez toujours su que les anatomistes n\'étaient pas très net dans leur tête, mais la façon avec laquelles ils ont créés et bus ces potions vous a vraiment déconcerté. Même l\'eau, si elle provient de la mauvaise coupe, peut être toxique, alors ne parlont même pas des concoctions qui sont distillées par ces anatomistes fous. Naturellement, il ne faudra pas longtemps avant qu'une de ces grosses têtes, %anatomist%, tombe malade. Il est encore capable de bouger et de faire ses tâches de tous les jours, mais les gigantesques verrues et les pustules dégoulinantes font de lui une horreur à regarder, et bien qu\'il se voit écarté de la compagnie, vous avez peu de doutes que tourner en rond en ressemblant à des loques qui ont essuyées du fumier soit sain pour l\'âme et l\'esprit. Avec de la chance, et un peu de temps, il pourra aller mieux. | %anatomist% n\'est pas nécessairement malade après avoir bu ses potions. Après tout, il peut toujours se déplacer et bourlinguer, et même se battre si c\'est nécessaire. Mais il est surement affecté par les dites potions d\'une manière des plus disgracieuse. De grands furoncles sont apparus sur ses joues, et occasionnellement ses yeux jaillissent de ses orbites et le fait qu\'il doive les pousser pour les rentrer est quelque chose que vous souhaitez ne jamais avoir vu. Des filets de baves tombent des coins de ses lèvres et sa narine abrite des escargots de morve ainsi que des crottes de nez et du sang. Comme vous pouvez l\'imaginer, il est plutôt abattu par le fait d\'être plus laid qu\'une carcasse de porc, mais vous avez foi que dans un bon moment il ira mieux.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Remets-toi vite sur pieds, %anatomist%.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.worsenMood(1.25, "Est contrarié de la façon dont ses mutations l'ont changés");

				if (_event.m.Anatomist.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				_event.m.Anatomist.getFlags().add("gotUpsetAtMutations");
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

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist" && !bro.getFlags().has("gotUpsetAtMutations") && bro.getFlags().getAsInt("ActiveMutations") > 0)
			{
				anatomistCandidates.push(bro);
			}
		}

		if (anatomistCandidates.len() == 0)
		{
			return;
		}

		this.m.Anatomist = anatomistCandidates[this.Math.rand(0, anatomistCandidates.len() - 1)];
		this.m.Score = 6 * anatomistCandidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getName()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
	}

});

